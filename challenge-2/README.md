# Terraform S3 Backend with Native Locking

이 프로젝트는 EC2 웹 서버를 생성하고 S3의 네이티브 잠금 기능을 사용하여 Terraform 상태를 관리하는 방법을 보여줍니다.

## 프로젝트 구조

- `variables.tf`: 기본 변수 정의
- `backend.tf`: S3 백엔드 설정
- `main.tf`: EC2 웹 서버 배포 코드
- `userdata.sh`: EC2 인스턴스의 시작 스크립트

## 사용 방법

### 1. S3 버킷 생성

먼저 AWS 콘솔이나 AWS CLI를 사용하여 S3 버킷을 생성합니다:

```bash
# AWS CLI로 S3 버킷 생성 예시
aws s3 mb s3://terraform-state-nickname-example --region ap-northeast-2
```

### 2. backend.tf 수정

`backend.tf` 파일에서 S3 버킷 이름을 1단계에서 생성한 버킷 이름으로 변경합니다:

```hcl
terraform {
  backend "s3" {
    bucket       = "여기에_생성한_버킷_이름_입력"
    # ... 나머지 설정 ...
  }
}
```

### 3. 변수 설정 (선택 사항)

필요에 따라 `variables.tf` 파일에서 리전이나 닉네임 값을 수정합니다.

### 4. Terraform 초기화 및 배포

```bash
terraform init
terraform apply
```

## S3 네이티브 잠금이란?

Terraform 1.10 버전부터 도입된 기능으로, DynamoDB 없이도 S3 자체의 기능만으로 상태 파일 잠금이 가능합니다. `use_lockfile = true` 옵션을 설정하면, Terraform은 상태 파일과 같은 위치에 `.tflock` 확장자를 가진 잠금 파일을 생성하여 동시 수정을 방지합니다.

## 버킷 생성 방식 비교

### AWS 콘솔이나 CLI로 S3 버킷 생성 후 Terraform에서 참조 (현재 방식)

**장점:**
- 부트스트랩 문제가 없음 (상태 파일을 저장할 S3 버킷이 이미 존재)
- 설정이 단순하고 직관적임
- 상태 파일 분리로 순환 의존성 문제 없음

**단점:**
- 일부 인프라가 코드로 관리되지 않음
- 전체 환경을 코드로 재현하기 어려움
- 버킷 생성 단계의 수동 작업 필요

## 주의사항

1. S3 버킷 이름은 전 세계적으로 고유해야 합니다.
2. Terraform 1.10 이상 버전이 필요합니다.
3. 닉네임은 `variables.tf` 파일에서 변경할 수 있습니다.
