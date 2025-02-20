MODULE MainModule
    CONST robtarget pHome:=[[329.55,-26.08,334.47],[0.000108947,-0.556346,-0.830951,-8.14346E-05],[-1,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget con_end:=[[618.51,7,267.36],[0.0217755,-0.18738,-0.982023,0.00667551],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget metal_box:=[[267.24,331.73,178.53],[0.00865659,-0.0140119,0.999794,0.0118651],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget plate:=[[16.67,-434.15,144.90],[0.0135598,-0.963797,-0.266286,-0.00164298],[-1,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget store:=[[11.84,460.10,119.47],[0.523329,-0.515442,-0.465964,-0.493278],[0,-3,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget cyl_top:=[[608.86,-438.72,480.63],[0.00184905,0.48747,0.873105,-0.00755194],[-1,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    VAR num x_pos :=0;
    VAR num y_pos :=0;

    VAR num x_val :=0;
    VAR num y_val :=0;
    VAR num z_val :=0;

    VAR num b_cnt :=0;
    VAR num w_cnt :=0;

    VAR num socket_chk :=0;
    
    ! VAR intnum interrupt_sign;

    ! Socket
    VAR socketdev server_socket;
    VAR socketdev client_socket;
    VAR string received_string;
    VAR bool keep_listening := FALSE;
    VAR socketstatus status_soc;
    VAR string client_ip;
    VAR num len;
    
    PROC main()
        ! Interrupt
        ! CONNECT interrupt_sign WITH E_STOP;
        ! ISignalDI di09_interrupt, high, interrupt_sign;
        ! IWatch interrupt_sign;
        
        AccSet 1, 1;
        PulseDO\PLength:=0.2,do02_plcstart;
        PulseDO\PLength:=0.2,do03_reset_jedg;

        MoveJ pHome, v300, fine, tool0;

        WHILE TRUE DO
            IF di06_arrive = 1 THEN

                con_end_proc;

                MoveJ pHome, v300, fine, tool0;

                IF di03_metal = 1 THEN
                    PulseDO\PLength:=0.2,do03_reset_jedg;
                    metal_proc;
                
                ELSEIF di04_plastic_black = 1 THEN
                    PulseDO\PLength:=0.2,do03_reset_jedg;
                    IF b_cnt > 4 THEN
                        cyl_proc;
                    ELSE
                        p_proc b_cnt, 0, 0;
                    ENDIF

                    b_cnt := b_cnt + 1;
                
                ELSEIF di05_plastic_white = 1 THEN
                    PulseDO\PLength:=0.2,do03_reset_jedg;
                    IF w_cnt > 4 THEN
                        cyl_proc;
                    ELSE
                        p_proc w_cnt, 0, -110;
                    ENDIF

                    w_cnt := w_cnt + 1;

                ENDIF

                IF b_cnt > 4 and w_cnt > 4 THEN
                    b_cnt := 0;
                    w_cnt := 0;
                    PulseDO\PLength:=0.2,do05_plc_stop;
                    socket_chk := 1;
                ENDIF

                MoveJ pHome, v300, fine, tool0;
            ENDIF

            ! Game Start
            IF socket_chk = 1 THEN

                keep_listening := TRUE;

                ! Socket
                SocketCreate server_socket;
                SocketBind server_socket, "10.10.32.145", 5000;
                SocketListen server_socket;
                SocketAccept server_socket, client_socket\ClientAddress:=client_ip;

                WHILE keep_listening DO
                    ! Waiting for a connection request
                    status_soc := SocketGetStatus(server_socket);
                    TPWrite "status_soc - " \num := status_soc;     
                    TPWrite client_ip;
                    
                    IF (status_soc = SOCKET_CLOSED) THEN
                        SocketAccept server_socket, client_socket;
                    ENDIF

                    ! Communication
                    SocketReceive client_socket \Str:=received_string;
                    TPWrite "Client wrote - " + received_string;
                    
                    len := StrLen(received_string);
                    
                    received_string := StrPart(received_string,1,2);

                    ! pos7:
                    
                    MoveJ pHome, v300, fine, tool0;

                    IF b_cnt <= w_cnt THEN
                        p_proc b_cnt, 1, 0;
                        b_cnt := b_cnt + 1;

                    ELSEIF b_cnt > w_cnt THEN
                        p_proc w_cnt, 1, -110;
                        w_cnt := w_cnt + 1;
                    ENDIF

                    which_store received_string;

                    received_string := "";
                    SocketSend client_socket \Str:="Message acknowledged"+client_ip;            
                    
                ENDWHILE
            
            ! ERROR
            ! IF ERRNO=ERR_SOCK_TIMEOUT THEN
            !     TPWrite "SOCK Time out Retry";
            !     RETRY;
            ! ELSEIF ERRNO=ERR_SOCK_CLOSED THEN
            !     RETURN;
            ! ELSE
            !     ! No error recovery handling
            ! ENDIF

            ENDIF

        ENDWHILE
    ENDPROC
    
    PROC grip_on()
        PulseDO\PLength:=0.2,do00_grip_on;           
        WaitDI di00_grip_on_sen,1;
    ENDPROC

    PROC grip_off()
        PulseDO\PLength:=0.2,do01_grip_off;
        WaitDI di01_grip_off_sen,1;
    ENDPROC

    PROC con_end_proc()
        MoveJ Offs(con_end,0,0,100), v300, z30, tool0;
        MoveL con_end, v30, fine, tool0;
        MoveL Offs(con_end,0,0,-25), v30, fine, tool0;
        grip_on;
        MoveL Offs(con_end,0,0,100), v100, z30, tool0;
    ENDPROC

    PROC cyl_proc()
        MoveJ Offs(cyl_top,0,0,100), v300, z30, tool0;
        MoveL cyl_top, v30, fine, tool0;
        MoveL Offs(cyl_top,0,0,-15), v30, fine, tool0;
        grip_off;
        MoveL cyl_top, v100, z30, tool0;
        MoveL Offs(cyl_top,0,0,100), v30, fine, tool0;
    ENDPROC 

    PROC metal_proc()
        MoveJ Offs(metal_box,0,0,100), v300, z30, tool0;
        MoveL metal_box, v30, fine, tool0;
        grip_off;
        MoveL metal_box, v100, z30, tool0;
    ENDPROC

    PROC p_proc(num cnt, num how, num calcu)
        x_pos := 110;
        x_pos := x_pos * cnt;

        MoveJ Offs(plate,x_pos,calcu,100),v300,z30,tool0;
        MoveL Offs(plate,x_pos,calcu,-20), v30, fine, tool0;

        IF how = 0 THEN
            grip_off;
        ELSE
            grip_on;
        ENDIF

        MoveL Offs(plate,x_pos,calcu,100), v100, z30, tool0;
    ENDPROC
    
    PROC which_store(string received_string)
        IF received_string="99" THEN
            MoveJ pHome, v300, fine, tool0;
        ELSE
            IF received_string="00" THEN
                x_val := -48;
                z_val := 150;
                y_val := 3;
            ENDIF
            
            IF received_string="10" THEN
                x_val := 2;
                z_val := 150;
                y_val := 2;
            ENDIF
            
            IF received_string="20" THEN
                x_val := 52;
                z_val := 150;
                y_val := 1;
            ENDIF

            IF received_string="01" THEN
                x_val := -50;
                z_val := 75;
                y_val := 3;
            ENDIF
            
            IF received_string="11" THEN
                x_val := 0;
                z_val := 75;
                y_val := 2;
            ENDIF
            
            IF received_string="21" THEN
                x_val := 50;
                z_val := 75;
                y_val := 1;
            ENDIF

            IF received_string="02" THEN
                x_val := -50;
                z_val := 0;
                y_val := 0;
            ENDIF
            
            IF received_string="12" THEN
                x_val := 0;
                z_val := 0;
                y_val := 0;
            ENDIF
            
            IF received_string="22" THEN
                x_val := 50;
                z_val := 0;
                y_val := 0;
            ENDIF

            MoveJ pHome, v300, fine, tool0;

            MoveJ Offs(store,x_val,-50,z_val),v200,z30,tool0;
            MoveL Offs(store,x_val,40,z_val), v30, fine, tool0;
            MoveL Offs(store,x_val,40+y_val,z_val-13), v10, fine, tool0;
            grip_off;
            MoveL Offs(store,x_val,-50,z_val), v100, z30, tool0;

            ! IF di19_storeA = 1 THEN
            !     PulseDO\PLength:=0.2,do04_buzzer;
            !     WaitDI di08_restart,1;
            !     ! GOTO pos7;
            ! ENDIF

        ENDIF
    ENDPROC
    
    ! TRAP E_STOP
    !     VAR robtarget e_stop_pos;
    !     StopMove;
    !     StorePath;
    !     e_stop_pos := CRobT();
        
    !     MoveJ pHome, v300, z50, tool0;
        
    !     WaitDi di09_interrupt,0;
    !     MoveJ e_stop_pos,v300, fine, tool0;
    !     RestoPath;
    !     StartMove;
    ! ENDTRAP
    
    
ENDMODULE