# 로봇팔을 이용한 삼목 게임  

1. PLC 프로그램이 작동하여 매거진에 쌓인 검은색 플라스틱, 흰색 플라스틱, 금속을 순차적으로 공급 및 컨베이어 작동  
![001](/images/photo/001.jpg){: width="100%" height="100%"}{: .center}  

2. 센서 인식을 통해 종류 확인  
![002](/images/photo/002.jpg){: width="100%" height="100%"}{: .center}  

3. 로봇팔이 흰색 플라스틱과 검은색 플라스틱을 플레이트에 정렬. 금속 플라스틱은 쓰레기통으로 이동.  
![003](/images/photo/003.jpg){: width="100%" height="100%"}{: .center}  

4. 흰색 플라스틱과 검은색 플라스틱이 5개씩 정렬되면 소켓을 연결하여 게임 시작. 단, 이미 5개가 정렬된 색의 물품이 선택되면 매거진에 다시 넣음.  
![004](/images/photo/004.jpg){: width="100%" height="100%"}{: .center}  

5. Web 화면에서 인간이 먼저 검은돌을 둔다. 그 다음 3초 후에 컴퓨터가 흰돌을 둔다. 이는 로봇팔이 플레이트에서 순차적으로 플라스틱을 선택하여 삼목판에 적재한다.  
![005](/images/photo/005.jpg){: width="100%" height="100%"}{: .center}  

6. 게임을 즐기다가 승자가 결정되면 게임이 마무리 된다.  
![006](/images/photo/006.jpg){: width="100%" height="100%"}{: .center}  


## PLC  

### 기본 설정  
![abb_project_plc_010](/images/plc/abb_project_plc_010.PNG){: width="100%" height="100%"}{: .center}  
  
![abb_project_plc_011](/images/plc/abb_project_plc_011.PNG){: width="100%" height="100%"}{: .center}  
  
![abb_project_plc_012](/images/plc/abb_project_plc_012.PNG){: width="100%" height="100%"}{: .center}  
  
![abb_project_plc_013](/images/plc/abb_project_plc_013.PNG){: width="100%" height="100%"}{: .center}  

### 프로그램  

![abb_project_plc_007](/images/plc/abb_project_plc_007.PNG){: width="100%" height="100%"}{: .center}  
  
![abb_project_plc_008](/images/plc/abb_project_plc_008.PNG){: width="100%" height="100%"}{: .center}  
  
![abb_project_plc_009](/images/plc/abb_project_plc_009.PNG){: width="100%" height="100%"}{: .center}  
  
![abb_project_plc_001](/images/plc/abb_project_plc_001.PNG){: width="100%" height="100%"}{: .center}  
![abb_project_plc_002](/images/plc/abb_project_plc_002.PNG){: width="100%" height="100%"}{: .center}  
![abb_project_plc_003](/images/plc/abb_project_plc_003.PNG){: width="100%" height="100%"}{: .center}  
![abb_project_plc_004](/images/plc/abb_project_plc_004.PNG){: width="100%" height="100%"}{: .center}  
![abb_project_plc_005](/images/plc/abb_project_plc_005.PNG){: width="100%" height="100%"}{: .center}  
![abb_project_plc_006](/images/plc/abb_project_plc_006.PNG){: width="100%" height="100%"}{: .center}  
  
### CC-Link 설정  
![abb_project_plc_014](/images/plc/abb_project_plc_014.PNG){: width="100%" height="100%"}{: .center}  


## RobotStudio RAPID  

### Signal 설정  
![abb_project_robot_001](/images/abb/abb_project_robot_001.PNG){: width="100%" height="100%"}{: .center}  

### 삼목판 좌표값에 대하여  
00 10 20  
01 11 21  
02 12 22  


## Web Node.js  
![web_01](/images/web/web_01.PNG){: width="100%" height="100%"}{: .center}  
  
![web_02](/images/web/web_02.PNG){: width="100%" height="100%"}{: .center}  
  
![web_03](/images/web/web_03.PNG){: width="100%" height="100%"}{: .center}  