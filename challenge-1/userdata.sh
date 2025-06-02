#!/bin/bash
# UTF-8 환경 설정
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export LANGUAGE=C.UTF-8

# 시스템 업데이트
apt-get update -y
apt-get upgrade -y

# Apache 웹 서버 설치
apt-get install -y apache2

# 기본 포트를 8080으로 변경
sed -i 's/Listen 80/Listen 8080/g' /etc/apache2/ports.conf
sed -i 's/:80/:8080/g' /etc/apache2/sites-available/000-default.conf

# 서비스 재시작
systemctl restart apache2

# UTF-8 설정을 포함한 index.html 파일 생성
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Terraform EC2 Challenge</title>
    <style>
        body {
            font-family: 'Noto Sans KR', Arial, sans-serif;
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background-color: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 600px;
        }
        h1 {
            color: #333;
        }
        .nickname {
            color: #0066cc;
            font-size: 2em;
            margin: 20px 0;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Terraform으로 배포된 EC2 웹 서버</h1>
        <p>닉네임:</p>
        <div class="nickname">${nickname}</div>
        <p>이 서버는 Terraform을 사용하여 자동으로 배포되었습니다.</p>
    </div>
</body>
</html>
EOF

# 웹 서버 실행 확인
systemctl enable apache2 