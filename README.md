# Terraform

Terraform 코드 정리하기


#연습중이라 아직은 변수없이 하드코딩으로 작성 해보는중#

--------------------------------------------------
terraform 에러 정리

1. terraform apply 실행중 작업 취소할 경우 lock이 걸려서 다음 명령어부터 -lock=false 라는 명령어를 추가적으로 쓰라고 하는데 이 방법은 terraform에서 권하지 않는다고 한다.
   unlock <lock ID> 명령어로 lock을 해제하라고 하는데 lock id가 찾아봐도 어디있는지 모르겠어서... 일단은 kill 명령어로 프로세스를 죽이고 재실행했더니 lock 뜨던 오류는 사라졌다.

2. ec2 생성 안되는 에러...
(Error launching source instance: UnauthorizedOperation: You are not authorized to perform this operatio)
