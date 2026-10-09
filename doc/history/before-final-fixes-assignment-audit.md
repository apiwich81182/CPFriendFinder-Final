# ตรวจเทียบใบงานและรายการงานค้าง — 9 ตุลาคม 2026

ตรวจจาก PDF ใบงาน CP353002 จำนวน 11 หน้า, source ปัจจุบันใน CPFriendFinder-NEW, Excel เดิม และผลรัน Java บนสำเนาที่จัดโครงสร้างใหม่ ไม่ใช้ Git commands ไม่ตรวจหรือแก้ประวัติ remote repository และไม่แก้ workbook

## งานของ Jiratchaya (Tester) ที่เหลือ

1. **แก้และยืนยัน full regression:** รอบนี้รัน 219 กรณี ผ่าน 205, failure 4, error 10 ไม่ใช่ 219/219 ผ่าน
   - `test/java/com/cp/friend/config/AuthSecurityWebMvcTest.java`: 10 error มีต้นเหตุร่วมคือ MVC slice โหลด `PageModelAdvice` แต่ไม่มี `UserService` bean ที่ advice ใช้ ต้องจัด test dependencies/scope แล้วรันใหม่ ไม่ถือว่าเป็น defect ใหม่ 10 เรื่องแยกกัน
   - `test/java/com/cp/friend/frontend/FrontendAuthContractTest.java`: 4 failures ที่ loginJavascript_callsCorrectBackendEndpoint, loginJavascript_storesUserAndRedirectsHome, registerJavascript_callsCorrectBackendEndpoint, registerJavascript_validatesPasswordAndRedirectsLogin เป็นการ assert ข้อความ source ที่ไม่ตรง JS ปัจจุบัน ต้องตรวจ contract/พฤติกรรมจริงก่อนปรับ tests ไม่เปลี่ยน assertion เพียงเพื่อทำให้เขียว
2. **รัน Robot ชุดเดิมบนโค้ดที่ทีมรวมล่าสุด** หลัง backend/frontend/deploy อยู่ revision เดียวกัน เก็บ output.xml/log.html/report.html/ภาพเมื่อ Fail และ revision + URL + เวลา ของรอบจริง Excel เดิมบันทึก Maven 180/180 และ Robot 5/5 เมื่อ 8 ตุลาคม เป็นหลักฐานรอบเก่า ไม่แทนรอบนี้
3. **เพิ่มกรณีอัตโนมัติ/ตรวจสองบัญชีสำหรับฟีเจอร์ใหม่:** โหลด bio/interests ล่าสุด, self edit, pending/incoming/accept, อัปโหลด/เรียง/ลบ gallery สูงสุด 5 รูป, text draft และ error recovery, ส่งรูปทั้ง room/friend, friend image history หลัง reload, group live-only history, room membership/call presence realtime, reconnect
4. **ตรวจเสียง/วิดีโอ/แชร์หน้าจอสองเครื่องจริงต่างเครือข่าย** รวมรับ/ปฏิเสธ/ยกเลิกสาย, voice→video, camera/mic on-off, หลายคนแชร์แล้วเลือกดู และ TURN relay อย่านับ fixture/browser checks ของผู้ช่วยเป็น physical-network E2E
5. **เติมผลจริงลง Excel เดิมโดยไม่ปรับรูปแบบ:** sheet `Test Case Design & Test Results` แถว 47–51 มี WEB-001–005 ที่ Actual Result ยังเป็น Not Run และ Status เป็น Waiting Frontend; WEB-R001–008 ที่มี Pass เป็นคนละ ID/รูปแบบตรวจ ไม่ได้ล้างรายการค้างเหล่านี้โดยอัตโนมัติ ต้องโยงหลักฐาน/retest ที่ตรงกรณี ไม่ลบประวัติเก่า
6. **ปิด defect และจัดรายงานสรุปรอบสุดท้าย** แยก source-string contract, unit/MVC, fixture browser, real E2E ให้ชัด ระบุ known gaps และรันซ้ำหลังทีม merge/deploy โดยไม่ใช้ process เก่าจาก snapshot เป็นหลักฐานของ branch ใหม่
7. **เตรียมอธิบายโค้ดทดสอบและหลักฐานส่วนตัว:** ใบงานกำหนดทุกคนเขียน code จริง, commit/push ด้วยบัญชีตนเอง, meaningful commits >=15 กระจายช่วงเวลา และ PR มี reviewer >=1 คน ยังไม่ได้ยืนยันจำนวน commit ของใครเพราะผู้ใช้ห้ามรัน Git อย่าสร้าง/เปลี่ยนประวัติย้อนหลังให้ดูเหมือนทำงานในช่วงเวลาที่ไม่ได้ทำ

Workbook คัดลอกแบบ byte-for-byte อยู่ `test/test-cases/CPFriendFinder_TestCases.xlsx` ไม่เติมผล 219 กรณีนี้ลง workbook ในรอบตรวจ/จัดไฟล์

## สิ่งที่ทีมยังต้องทำตามใบงาน

| ข้อ/หน้าใบงาน | สถานะจาก source และไฟล์ที่พบ | งานต่อ / เจ้าของหลัก |
|---|---|---|
| Technical, หน้า 1–2 | มี Java21/Spring Boot4.1.1/Maven/JPA/SQL/Thymeleaf/JUnit/Mockito/OpenAPI dependencies | ตรวจ runtime/deploy จริงร่วมกัน |
| Layered Architecture, หน้า 2 | โครงสร้างหลักมี แต่ `ProfileSummaryController.java:16–31` และ `RoomPresenceController.java:17–21` เรียก Repository ตรง | Piyapon ย้าย business/data access ไป Service โดยรักษา session/membership checks และเพิ่ม regression tests |
| SOLID, หน้า 3–4 | ยังไม่มี `doc/solid-analysis.md`; พบ service ที่พึ่ง concrete service เช่น UserService→UserInterestService และ ChatMessageService→NotificationService | Piyapon/ทีมตรวจ S/O/L/I/D ตามการใช้จริง เขียนพาธ+บรรทัด+เหตุผล ไม่อ้างเพียง annotation |
| GoF, หน้า 5 | มีหลักฐาน Behavioral 3 แบบ: Strategy (MessageContentStrategyResolver/MatchingStrategy), Observer (FriendRequest events/NotificationService), Template Method (AbstractMessageContentStrategy) | มีแนวทางครบหนึ่งกลุ่ม แต่ยังไม่มี `doc/design-patterns.md` ตารางเหตุผลและ Class Diagram; ไม่จำเป็นต้องยัดครบทั้งสามกลุ่ม |
| DB >=6 tables, หน้า 5 | Entity/collection tables มากกว่า 6 ตาราง มี foreign-key relationships ใน mappings | จัด ER/Data Dictionary และตรวจ index/constraints ของ schema จริง |
| One-to-One และ One-to-Many, หน้า 5 | ไม่พบ `@OneToOne` ใน source; มี ManyToOne ที่สื่อความสัมพันธ์ฝั่ง one-to-many แต่ยังไม่มี ER ยืนยัน | Piyapon ออกแบบ One-to-One ที่มี use case จริง และอธิบาย one-to-many/FK/fetch/cascade ไม่สร้างตารางเปล่าเพื่อให้ครบ |
| Migration, หน้า 6 | ไม่พบ Flyway/Liquibase หรือ schema.sql + data.sql; การใช้ ddl-auto=update อย่างเดียวไม่ครบข้อนี้ | Piyapon เตรียม migration/schema และ initial reference data ที่ไม่ใช่บัญชีเทส/ข้อมูลส่วนตัว |
| CRUD >=2 resources, หน้า 6 | ยังไม่พบสอง resources ที่ครบชัดเจน: rooms มี create/read/update แต่ไม่มี DELETE; interests มี create/read; messages มี create/read/delete แต่ไม่มี update | ทีมเลือก 2 resources และกำหนด update/delete/authorization/soft-delete ที่ตรง use case แล้วทดสอบ |
| Validation/error/DTO, หน้า 6 | พบ request validation, GlobalExceptionHandler, DTO/Mapper | Jiratchaya ตรวจ negative cases และ HTTP/status/response จริงต่อ |
| Pagination + Sorting, หน้า 6 | มี PageRequest/page-size และ queries เรียงผลบางรายการ ยังไม่พบ sort parameter ที่ public endpoint | Piyapon ยืนยันการเรียงตามเกณฑ์ใบงาน/เพิ่ม sort ที่เหมาะสม แล้วทดสอบร่วมกับ pagination |
| Swagger, หน้า 6 | มี Springdoc/UI config และ allowlist | Apiwich/Jiratchaya ต้องเปิด Swagger ได้บน deploy ณ วันนำเสนอ ไม่ถือว่ามี dependency แล้วผ่าน runtime |
| Branch/commit/PR, หน้า 7–8 | รู้ branch 4 คนจากภาพ; คนที่ 5 ยังไม่ทราบ branch/หน้าที่ | แต่ละคนตรวจชื่อ branch/บัญชี/15 commits/PR review ด้วยตนเอง; อย่าฝากคนอื่น commit/push |
| Repository folders, หน้า 8 | สำเนา ZIP นี้จัด code/test/doc/img แล้ว แต่ repository ต้นฉบับไม่ได้ย้าย | ให้ทีมรวมโครงสร้างครั้งเดียว ก่อนแบ่งงานต่อ ไม่เปิด PR ทั้ง snapshot ซ้ำหลายคน |
| Diagrams, หน้า 9 | ไม่พบชุด diagrams ที่ส่งจริง | Use Case+Description, Domain Model, Class+Patterns, Sequence >=3 scenarios, Activity, ER, Component, Deployment, State (ระบบมี statuses จึงต้องมี State) |
| README, หน้า 9–10 | README เดิมมีเพียงรายละเอียด/รายชื่อ; ฉบับ ZIP เพิ่ม setup/run/test/architecture/structure และหน้าที่ที่ทราบ | เติม branch/section/หน้าที่ของปองภพ และเชื่อม ER/diagrams/URL production เมื่อทำจริง |
| Deploy, หน้า 10 | มี Dockerfile; ไม่พบ docker-compose.yml; มี temporary tunnel เดิม | Apiwich เตรียม compose, deploy URL ที่เข้าถึงได้วันนำเสนอ และยืนยัน DB/storage/TURN/config ฝั่ง server |
| CI/CD, หน้า 10 | ไม่พบ GitHub Actions workflow; .github ที่พบเป็น developer tool hooks | เป็นคะแนนพิเศษ ไม่ใช่เงื่อนไขบังคับ ให้ทำหลังส่วนบังคับครบ |
| Presentation, หน้า 11 | ไม่พบ slides | ทีมจัด `doc/slide/` และซ้อมอธิบายโค้ด/สถาปัตยกรรม/ผลทดสอบของแต่ละคน |
| Final delivery, หน้า 11 | ยังไม่ตรวจ main/PR/release และ URL วันนำเสนอ | หลังตรวจครบ จึงรวม release เข้า main ผ่าน PR ตามที่ทีมอนุมัติ |

## ขอบเขตการจัดโฟลเดอร์รอบนี้

- จัด **สำเนา** ทั้งโปรเจกต์ ไม่มี .git และไม่แก้ต้นฉบับ/ระบบที่กำลังรัน
- Java production/templates/static อยู่ code/src/main; Java tests ย้ายไป test/java และ POM ชี้ตำแหน่งใหม่; Robot/Excel/แผนเทสอยู่ test/ ตามเดิม
- เก็บเอกสารเดิมใน doc/history เพื่อแยกจาก README/รายงานตรวจปัจจุบัน ไม่แก้ timestamps/ผลเก่าหรืออ้างว่าเอกสารเก่าคือหลักฐาน release ใหม่
- สร้าง doc/diagrams กับ doc/slide เป็นตำแหน่งสำหรับงานที่จะต้องเติม ยังไม่มี diagrams/slides จริง `.gitkeep` ไม่ถือว่าเอกสารครบ
- ภาพ UI fixture จากรอบก่อนอยู่ img/ui-verification ส่วนรูปที่เว็บต้องใช้ยังอยู่ code/src/main/resources/static/images เพื่อรักษา URL
- เอา backup_call.js/backup_friend.js ที่ไม่พบการอ้างอิงออกเฉพาะสำเนาส่ง ไม่ลบต้นฉบับ
- ไม่รวมข้อมูลฐานข้อมูลจริง/ผู้ใช้/ไฟล์ object storage; ผู้รับต้องตั้งค่าบริการเองด้วย environment variables

## หลักฐานและข้อจำกัด

ผล Java รอบนี้อยู่ `doc/review/package-verification.json` และ `java-test-summary.json` เป็นข้อมูลตรวจที่ sanitize แล้ว ไม่รวม raw runtime logs ที่อาจมีค่าลับ ไม่มีการรัน Robot หรือ Docker build ในรอบนี้ ไม่มีการแก้ปัญหา full regression ให้ผ่านหรือ refactor business code ระหว่างจัดไฟล์ รายงานนี้ระบุงานที่ยังต้องทำตามที่พบจริง
