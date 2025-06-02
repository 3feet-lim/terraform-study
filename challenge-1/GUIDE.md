# Terraform EC2 웹 서버 배포 가이드

## 개요
이 프로젝트는 AWS EC2 인스턴스에 웹 서버를 배포하는 Terraform 코드입니다. 웹 서버는 8080 포트에서 실행되며, 닉네임을 표시하는 간단한 웹 페이지를 제공합니다.

## 사전 요구 사항
- Terraform 설치 (v1.12.1)
- AWS CLI 설치 및 구성
- AWS 계정 및 적절한 권한

## 사용 방법

### 1. 초기화
다음 명령어로 Terraform을 초기화합니다:
```bash
terraform init
```

### 2. 변수 설정 (선택 사항)
기본값을 사용하지 않고 변수를 설정하려면 `terraform.tfvars` 파일을 생성하거나 명령줄에서 지정할 수 있습니다:

```bash
# terraform.tfvars 파일 예시
ubuntu_version = "20.04"
architecture = "arm64"
instance_type = "t3.micro"
nickname = "My Server"
```

또는 명령줄에서 변수를 지정:
```bash
terraform apply -var="ubuntu_version=20.04" -var="architecture=arm64"
```

### 3. 계획 확인
배포될 리소스를 미리 확인합니다:
```bash
terraform plan
```

### 4. 리소스 생성
다음 명령어로 리소스를 생성합니다:
```bash
terraform apply
```
프롬프트에서 `yes`를 입력하여 배포를 확인합니다.

### 5. 출력 확인
배포가 완료되면 다음과 같은 출력을 확인할 수 있습니다:
- 웹 서버의 공용 IP 주소
- 웹 서버 URL (http://[IP]:8080)
- 선택된 AMI 정보

### 6. 리소스 그래프 확인
리소스 관계 그래프를 확인하려면 다음 명령어를 실행합니다:
```bash
terraform graph | dot -Tsvg > graph.svg
```
(dot 유틸리티는 GraphViz 패키지의 일부입니다. 필요한 경우 설치해야 합니다.)

### 7. 리소스 삭제
다음 명령어로 생성된 모든 리소스를 삭제할 수 있습니다:
```bash
terraform destroy
```
프롬프트에서 `yes`를 입력하여 삭제를 확인합니다.

## 사용 가능한 변수
| 변수명 | 설명 | 기본값 | 허용 값 |
|-------|------|-------|--------|
| ubuntu_version | Ubuntu 버전 | 22.04 | 18.04, 20.04, 22.04, 23.04, 23.10 등 |
| architecture | 인스턴스 아키텍처 | x86_64 | x86_64, arm64 |
| instance_type | EC2 인스턴스 타입 | t2.micro | AWS에서 지원하는 인스턴스 타입 |
| nickname | 웹 페이지에 표시할 닉네임 | Blessed Dragon | 문자열 |

## 파일 구조
- `main.tf`: 주요 Terraform 구성 파일
- `variables.tf`: 변수 정의 파일
- `versions.tf`: Terraform 및 프로바이더 버전 설정
- `userdata.sh`: 웹 서버 설정을 위한 스크립트
- `.gitignore`: Git에서 무시할 파일 목록

## 참고 사항
- 이 프로젝트는 기본적으로 서울 리전(ap-northeast-2)에 배포됩니다.
- 보안 그룹은 SSH(22)와 웹 서버(8080) 포트를 허용합니다.
- 웹 페이지는 UTF-8 인코딩을 사용하여 한글을 올바르게 표시합니다.
- 이 프로젝트는 Terraform의 내장 함수인 `templatefile`을 사용하여 userdata 스크립트를 렌더링합니다.
- AWS에서 제공하는 데이터 소스를 사용하여 최신 Ubuntu AMI를 자동으로 찾습니다. 