# Terraform 도전과제 1

## EC2 웹 서버 배포 + 리소스 생성 그래프 확인

- **Ubuntu** 에 apache(**httpd**) 를 설치하고 **index.html** 생성(**닉네임** 출력)하는 **userdata** 를 작성해서 설정 배포 후 웹 접속 - 해당 **테라폼 코드(파일)를 작성**
- (옵션) **userdata** 부분은 **별도의 파일**을 참조할 수 있게 **data 블록**을 활용 할 것 → 아래 링크를 참고해보자
    
    https://developer.hashicorp.com/terraform/tutorials/provision/cloud-init
    
- 참고 : **[hashicat-aws](https://github.com/hashicorp/hashicat-aws) | [hashicat-azure](https://github.com/hashicorp/hashicat-azure) | [hashicat-gcp](https://github.com/hashicorp/hashicat-gcp) | [hashicat-ncloud](https://github.com/ncp-hc/hashicat-ncp)** → CSP 환경별 HashiCat 샘플 애플리케이션을 커스텀 해보셔도 됩니다!
- 참고 : [Intro to Terraform on Azure](https://docmoa.github.io/04-HashiCorp/03-Terraform/03-Sample/hashicat-azure.html)