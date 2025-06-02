# S3 백엔드 설정
# 이 파일은 하드코딩된 백엔드 설정을 포함합니다.
# 아래의 버킷 이름은 AWS 콘솔이나 CLI를 통해 미리 생성된 S3 버킷 이름으로 변경해야 합니다.

terraform {
  required_version = ">= 1.10.0"
  
  backend "s3" {
    bucket       = "tfstate-vlab-poc"  # 미리 생성된 S3 버킷 이름으로 변경해야 함
    key          = "t1014/challenge-2/terraform.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true  # S3 네이티브 잠금 기능 활성화
  }
}