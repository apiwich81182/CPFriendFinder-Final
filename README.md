# CP Friend Finder

ระบบช่วยนักศึกษาแนะนำเพื่อนจากความสนใจและข้อมูลการศึกษา จัดการคำขอเพื่อนและโปรไฟล์ คุยในห้องกลุ่มหรือแชทเพื่อน และคอลเสียง/วิดีโอพร้อมแชร์หน้าจอผ่าน WebRTC

ฉบับแก้โค้ดและจัดไฟล์ส่งต่อทั้งโปรเจกต์ ดูผลตรวจล่าสุดใน `doc/review/final-release.md` และรายการส่งงานใน `doc/review/assignment-audit.md` ZIP นี้ไม่มี Git history, ข้อมูลฐานข้อมูลจริง หรือ key ของบริการ ต้องให้ทีมตรวจการ deploy และการคอลสองเครื่องก่อนส่งจริง

## สมาชิกกลุ่ม

| ลำดับ | ชื่อ | รหัสนักศึกษา | Section | Branch ที่ได้รับแจ้ง | หน้าที่ |
|---|---|---|---|---|---|
| 1 | ปองภพ ศรีรักษ์ | 673380279-7 | รอยืนยัน | รอยืนยัน | รอทีมยืนยัน |
| 2 | ปิยพนธ์ แก้วเก็บคำ | 673380050-9 | 01 | piyapon_673380050-9_01 | Backend |
| 3 | โยโกะ คามิโจ | 673380302-8 | 01 | Yoko_673380302-8_01 | Frontend |
| 4 | จิรัชญา เป้าจันทึก | 673380510-1 | 01 | jiratchaya_673380510-1_01 | Tester / JUnit / Robot Framework |
| 5 | อภิวิชญ์ เอกะ | 673380517-7 | 01 | apiwich_673380517-7_01 | Deployment |

ชื่อ/รหัสมาจาก README เดิม หน้าที่/branch มาจากข้อมูลที่ผู้ใช้แจ้ง ยังไม่ได้ตรวจประวัติ Git หรือการตั้งค่าบัญชีของแต่ละคน

## Tech Stack

Java 21, Spring Boot 4.1.1, Maven, Spring Data JPA, PostgreSQL, Spring Security, Thymeleaf, JavaScript/CSS, WebSocket/STOMP, WebRTC, Node.js gateway, S3-compatible storage, Cloudflare TURN, Springdoc OpenAPI, JUnit/Mockito และ Robot Framework Browser

## System Architecture

Browser/Thymeleaf → REST Controller → Service → Repository → SQL

WebSocket/STOMP ส่งข้อความและสัญญาณคอล; WebRTC ส่งสื่อระหว่างผู้ใช้โดยมี TURN เป็น relay เมื่อจำเป็น Node gateway รวมหน้าเว็บ/API/WebSocket ที่ localhost:3000 และขอ TURN credentials ฝั่ง server

Controller อ่านข้อมูลผ่าน Service แล้ว รายละเอียด SOLID อยู่ `doc/solid-analysis.md` และ Behavioral GoF 3 แบบอยู่ `doc/design-patterns.md`

## Database Design

Entity อยู่ใน `code/src/main/java/com/cp/friend/model/` มี users, interests, friendships, friend_requests, rooms/messages/notifications และตารางที่เกี่ยวข้อง รวม gallery collection มีมากกว่า 6 ตาราง

มี User–UserProfile แบบ One-to-One และ Room–RoomMember แบบ One-to-Many; schema/data สำหรับฐานข้อมูลใหม่ และ upgrade script สำหรับฐานข้อมูลเดิมอยู่ใน resources ดู `doc/database.md`, `doc/data-dictionary.md` และ `doc/diagrams/er.mmd` ห้ามรัน schema ใหม่ทับฐานข้อมูลเดิม

## Installation & Setup

ต้องมี JDK 21, ฐานข้อมูล PostgreSQL, S3-compatible storage และ Node.js ที่มี built-in fetch สำหรับ gateway

```bash
cd code
cp .env.example .env
```

เติมค่าใน `.env` เฉพาะเครื่องตัวเอง อย่าส่ง key ลงแชทหรือ Git ตัวอย่าง application.properties ใช้ environment variables ไม่มีรหัสจริง Maven/Spring/Node ไม่โหลด `.env` ให้เอง ให้โหลดก่อนเริ่มระบบ:

```bash
set -a
source .env
set +a
```

ต้องใส่ DB_URL/DB_USERNAME/DB_PASSWORD และ AWS_ENDPOINT_URL_S3/AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY/AWS_REGION ให้ตรงกับระบบของทีม ถ้า internal storage URL ต่างจาก URL ที่ browser เปิดได้ ให้ตั้ง AWS_PUBLIC_URL_S3 เพิ่ม ไม่รวมข้อมูลบัญชีและไฟล์ใน object storage ไว้ใน ZIP สำหรับฐานข้อมูลใหม่ให้รัน schema.sql/data.sql ตาม `doc/database.md` ก่อนใช้ JPA_DDL_AUTO=validate

TURN ใช้ CLOUDFLARE_TURN_KEY_ID และ CLOUDFLARE_TURN_API_TOKEN ฝั่ง Node หรือสร้าง `.cloudflare-turn.json` ส่วนตัวภายใน code/ เท่านั้น ไม่ใส่ credential ใน frontend หากไม่ตั้ง TURN บางเครือข่ายอาจคอลไม่ได้

## How to Run

Terminal แรก อยู่ที่ code/ หลังโหลด environment:

```bash
bash mvnw spring-boot:run
```

Terminal ที่สอง เปิดที่โฟลเดอร์โปรเจกต์ใหม่:

```bash
cd code
set -a
source .env
set +a
node server.js
```

เปิด http://localhost:3000/login ผ่าน gateway เพื่อใช้ TURN และ media proxy; backend โดยตรงใช้ได้สำหรับ REST/UI แต่ไม่มี Node TURN endpoint HTTPS จำเป็นสำหรับกล้อง/แชร์หน้าจอเมื่อใช้งานผ่าน URL ภายนอก localhost

## API Documentation

เปิด http://localhost:8080/swagger-ui.html หรือ /swagger-ui/index.html และ OpenAPI JSON ที่ /v3/api-docs หลังเริ่ม backend

## How to Run Tests

Java tests ย้ายมาอยู่ test/java แล้ว POM ใน code/ ชี้มาที่ตำแหน่งนี้:

```bash
cd code
bash mvnw test
```

รายงาน Maven อยู่ code/target/surefire-reports หลังรัน ไม่รวม raw runtime output ใน ZIP สำหรับ Robot เปิด terminal ที่ root ของโปรเจกต์:

```bash
python -m venv .venv-robot
./.venv-robot/Scripts/python.exe -m pip install -r test/requirements-robot.txt
./.venv-robot/Scripts/python.exe -m Browser.entry init chromium
./.venv-robot/Scripts/python.exe -m robot \
  --variable BASE_URL:http://localhost:3000 \
  --outputdir test/e2e/robot/results/local-run \
  test/e2e/robot/tests
```

คำสั่ง Python ด้านบนสำหรับ Windows Git Bash; Linux/macOS ใช้ .venv-robot/bin/python แทน Scripts/python.exe Robot เดิมมี 5 กรณี auth/register/interests ยังไม่ครอบคลุมฟีเจอร์ใหม่หรือสองเครื่องจริง Excel เดิมอยู่ test/test-cases/CPFriendFinder_TestCases.xlsx และคัดลอกแบบไม่แก้ไข

ผล Java จากการตรวจสำเนานี้ดู doc/review/package-verification.json เป็นคนละรอบกับ Excel เดิม ไม่ใส่ผลลง Excel โดยอัตโนมัติ

## Deployment URL

ลิงก์ทดลองที่เคยใช้: https://life-train-operator-emily.trycloudflare.com/login เป็น temporary tunnel จึงอาจหมดอายุ ไม่ยืนยันว่าเป็น production deployment ที่พร้อมวันนำเสนอ ต้องให้ Apiwich ระบุ URL deploy จริงและตรวจพร้อม Swagger/คอลสองเครือข่าย

มี Dockerfile รวม Java backend + Node gateway และ compose สำหรับ PostgreSQL/MinIO เปิด terminal ที่ root ของโปรเจกต์:

```bash
cp .env.example .env
# เติมค่าของตัวเองใน .env ก่อน (รหัส DB, MinIO และ TURN ถ้ามี)
docker compose up --build -d
# เมื่อพร้อม เปิด http://localhost:3000/login
```

ตรวจรูปแบบ compose แล้ว แต่ Docker engine ของเครื่องไม่ทำงานจึงยังไม่ได้ build/run stack จริง; `minio/minio:latest` และ `minio/mc:latest` ควร pin digest หลังทีมตรวจ deploy สำเร็จ ไม่มี CI/CD (คะแนนพิเศษ) ห้ามใช้คำสั่งลบ volume กับฐานข้อมูลที่ต้องเก็บ ประเด็น HTTPS/public URL ต้องตั้งบนโฮสต์จริง ดู `doc/deployment.md`

## Project Structure

```text
README.md
code/                  Spring Boot app, Maven, Dockerfile, gateway/TURN helpers
  src/main/            Java production code, Thymeleaf, static assets
  .mvn/                Maven wrapper configuration
  pom.xml              Test source path points to ../test/java
test/
  java/                JUnit/Mockito tests
  e2e/robot/           Existing Robot cases and resources
  test-cases/          Original Excel workbook
  test-plan/           Original testing plan
doc/
  review/              Assignment audit and sanitized verification
  history/             Existing reports, former handoff instructions and README
  diagrams/            Diagram sources + use case descriptions
  slide/               Presentation outline; team finalizes actual slides
img/
  ui-verification/     Earlier UI fixture screenshots, not physical-user evidence
```

ภาพที่เว็บใช้ยังอยู่ code/src/main/resources/static/images เพื่อรักษา URL เดิม ส่วน img/ สำหรับสื่อประกอบส่งงาน ประวัติรายงานใน doc/history อาจอ้างพาธเดิมของเครื่องหรือวิธีแบ่ง PR รอบเก่า ใช้ README ฉบับนี้และ doc/review/handoff.md เป็นแนวทางของ ZIP นี้

## Additional regression checks

Native browser fixture checks (no live accounts) are under `test/browser/`:

```bash
cd test/browser
npm install
npx playwright install chromium
# Windows Edge is used by default; set BROWSER_CHANNEL=chromium for bundled Chromium
npm test
```

`api-isolated.py` creates accounts and records **only for a disposable localhost test database**; do not run it against the real local/shared database. See `test/browser/README.md`. Test result scopes are kept separate; none of these checks replaces two physical devices on different networks. The original Excel remains unchanged until actual results are approved for its existing format.
