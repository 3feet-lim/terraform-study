variable "ubuntu_version" {
  description = "Ubuntu 버전"
  type        = string
  default     = "22.04"
}

variable "architecture" {
  description = "인스턴스 아키텍처"
  type        = string
  default     = "x86_64"
  validation {
    condition     = contains(["x86_64", "arm64"], var.architecture)
    error_message = "아키텍처는 x86_64 또는 arm64만 지원합니다."
  }
}

variable "instance_type" {
  description = "인스턴스 타입"
  type        = string
  default     = "t2.micro"
}

variable "nickname" {
  description = "웹 페이지에 표시할 닉네임"
  type        = string
  default     = "Blessed Dragon"
} 