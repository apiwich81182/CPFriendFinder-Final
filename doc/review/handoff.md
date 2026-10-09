# การส่งต่อโปรเจกต์ทั้งชุด

1. แตก CPFriendFinder-final-2026-10-10.zip ไปที่โฟลเดอร์ใหม่ว่าง เช่น CPFriendFinder-organized ห้ามแตกทั้งชุดทับ repository ที่มีงานค้าง
2. เปิด README.md และ code/pom.xml ยืนยัน Java 21 ตั้งค่า environment ส่วนตัวตาม code/.env.example แล้วลอง build/test จาก code/
3. ZIP ไม่มี .git จึงไม่มีประวัติ commit/branch และไม่ล้าง conflict ของ repository เดิมโดยอัตโนมัติ การเพิ่มโฟลเดอร์ code/ และย้าย Java tests เป็นการเปลี่ยนพาธจริง
4. ให้ทีมเลือกผู้รวมโครงสร้างครั้งเดียวใน branch ที่ตกลงร่วมกันก่อน แล้วจึงแบ่งงานต่อ อย่าให้ทุกคนคัดลอกทั้ง ZIP ไปเปิด PR ซ้ำกัน เพราะจะเกิดการแก้ไฟล์ร่วมและ conflict อีก
5. เก็บ repository เดิมและไฟล์ตั้งค่าลับเดิมไว้ส่วนตัว อย่าแทนที่หรือลบ .git / งานของเพื่อน การนำสำเนานี้กลับเข้า repository ต้องตรวจ diff โดยเจ้าของงานและผ่าน review
6. ทดสอบโค้ดที่รวมจริงอีกครั้ง บันทึก revision/environment/ผลจริงใน Excel เดิม ไม่ใช้ผล Maven ของ snapshot นี้ยืนยันว่า branch ที่ merge ผ่านแล้ว
7. สมาชิกแต่ละคนตรวจและอธิบายโค้ดของตนเอง commit/push ด้วยบัญชีตนเองตามใบงาน ไม่เปลี่ยนประวัติหรือ attribution เพื่อแสดงผลงานที่ไม่ตรงจริง

## สิ่งที่ไม่รวม

Live application.properties, .cloudflare-turn.json, .turn-servers.json, database/account recovery SQL, .git, target, node_modules, .venv-robot, old ZIPs, raw backend logs และ JUnit environment/system properties และ developer tool hooks

Excel อยู่ใน test/test-cases/ และคัดลอก byte-for-byte ชุดทดสอบและรายงานเก่าเก็บตามเดิม มีผล Robot ใหม่จากฐานข้อมูล H2 แยกใน test/evidence พร้อมหลักฐาน fail/retest; ไม่ใช่ผลคอลสองเครื่อง รูป UI ใน img/ui-verification เป็นหลักฐานที่ใช้ fixture จากรอบก่อน ไม่ใช่ผลผู้ใช้จริงสองเครื่อง

## การตรวจความลับ

สำเนา application.properties มีเฉพาะ environment placeholders; .env.example ไม่มีรหัสจริง ตรวจไฟล์ใน ZIP เทียบค่าลับจาก local config โดยไม่แสดงค่า รวมถึง XML ภายใน Excel และตรวจ private-key/token patterns ค่าทดสอบตัวอย่างใน JUnit/Robot ไม่ใช่รหัสบริการจริง ผู้รับต้องตั้งค่าบริการของตนเอง
