# redduk.log

컴퓨터공학 학습 기록을 위한 GitHub Pages 블로그입니다.

## 글 작성

posts 폴더에 확장자가 .txt인 글 파일을 추가하거나 수정한 뒤 GitHub에 푸시하세요. GitHub Actions가 모든 글 파일을 읽어 블로그에 필요한 posts.json을 자동으로 생성합니다. 글마다 별도 업로드 명령을 실행할 필요가 없습니다.

글 파일 예시(posts/stack.txt):

~~~~text
title: 스택 기초
category: Computer Science
date: 2026-07-30
id: stack-basics

---

스택은 마지막에 넣은 값을 먼저 꺼내는 자료구조입니다.

## 기본 연산

~~~
push(10)
pop()
~~~
~~~~

메타데이터와 본문 사이의 --- 줄은 반드시 필요합니다. id는 글 주소에 쓰이므로 글마다 고유해야 하며 영문 소문자·숫자·한글·하이픈만 사용할 수 있습니다.

변경 사항은 아래처럼 GitHub에 반영하면 됩니다.

~~~powershell
git add .
git commit -m "Add post"
git push
~~~

GitHub 저장소 설정에서 Pages의 배포 원본을 main 브랜치의 루트(/)로 지정하세요. 또한 Actions의 Workflow permissions가 읽기/쓰기 권한을 허용해야 자동 생성된 posts.json을 커밋할 수 있습니다.
