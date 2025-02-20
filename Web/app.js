const net = require("net");
const express = require("express");

const SERVER_HOST = "10.10.32.145";
const SERVER_PORT = 5000;

const app = express();
app.use(express.static("public"));

// TCP 클라이언트 설정
const client = new net.Socket();
client.connect(SERVER_PORT, SERVER_HOST, () => {
    console.log(`서버(${SERVER_HOST}:${SERVER_PORT})에 연결됨`);
});

client.on("data", (data) => {
    console.log(`서버 응답: ${data.toString()}`);
});

// delay 함수 정의
function delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

app.get("/move", async (req, res) => {
    const { human, computer } = req.query;

    // console.log(human); // 11,22,00 이런 식으로 오게 됨.
    // console.log(computer);
    
    if (human && computer) {
        let lastHuman = human.split(',').pop();  // 마지막 숫자 추출
        let lastComputer = computer.split(',').pop();  // 마지막 숫자 추출

        console.log(`웹에서 받은 인간의 좌표: ${lastHuman}`);
        await client.write(lastHuman); // await로 지연 처리
        
        await delay(3000); // 인간 두기 -> 3초 지연 -> 로봇 두기
        
        console.log(`웹에서 받은 컴퓨터의 좌표: ${lastComputer}`);
        await client.write(lastComputer); // await로 지연 처리

    } else {
        console.log("좌표 데이터 없음");
    }

});

app.listen(3000, () => {
    console.log("웹 서버 실행 중: http://localhost:3000");
});