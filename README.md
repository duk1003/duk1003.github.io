# redduk.log

컴퓨터공학 학습 기록을 위한 GitHub Pages 블로그입니다.

## 글 작성

PowerShell에서 아래 명령을 실행합니다.

```powershell
.\new-post.ps1
```

- 게시일은 실행 시점으로 자동 기록됩니다.
- 분류는 원하는 이름을 자유롭게 입력할 수 있습니다.
- 본문 입력을 끝낼 때는 새 줄에 `END`만 입력합니다.
- 코드 블록은 새 줄에 `/code`를 입력해 시작하고, `/endcode`를 입력해 끝냅니다.

예를 들어 본문을 아래처럼 입력하면 가운데 부분이 코드 블록으로 게시됩니다.

```text
이 명령을 실행합니다.
/code
git status
git push
/endcode
END
```

글을 저장한 뒤 아래처럼 GitHub에 반영하면 됩니다.

```powershell
git add posts.json
git commit -m "Add post"
git push
```

GitHub 저장소 설정에서 Pages의 배포 원본을 `main` 브랜치의 루트(`/`)로 지정하세요.
