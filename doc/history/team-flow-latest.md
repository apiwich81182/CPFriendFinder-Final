# ลำดับส่งงานอัปเดตล่าสุด — 9 ตุลาคม 2026

ใช้ `develop` เป็น branch กลางตามภาพ ไม่ใช้ `main` เป็นปลายทาง PR รอบนี้ และยังไม่มีการใช้คำสั่ง Git หรือเปิด PR โดยผู้ช่วย

## ใครทำก่อนและใครรับต่อ

| ลำดับ | ผู้รับผิดชอบ / branch ต้นทาง | ชุดไฟล์ | PR ไปที่ | ผู้ตรวจหลัก / ส่งต่อ |
|---|---|---|---|---|
| 1 | Piyapon — `piyapon_673380050-9_01` | `01-piyapon-backend.zip`: Java และ Java tests | `develop` | Jiratchaya ตรวจผลทดสอบ; Yoko ตรวจ API ที่ frontend ใช้ แล้ว merge ก่อนส่งต่อ |
| 2 | Yoko — `Yoko_673380302-8_01` | `02-yoko-frontend.zip`: templates/static รวมไฟล์ที่แชร์หลายฟีเจอร์ | `develop` | Piyapon ตรวจการเรียก API; Jiratchaya ตรวจ flow แล้ว merge |
| 3 | Apiwich — `apiwich_673380517-7_01` | `03-apiwich-deploy.zip`: gateway/TURN และคู่มือตั้งค่า | `develop` | Piyapon ตรวจการเชื่อม backend; Yoko ตรวจหน้าเว็บ แล้ว merge และ deploy ชุดรวม |
| 4 | Jiratchaya — `jiratchaya_673380510-1_01` | `04-jiratchaya-tests-docs.zip` + ผลรันจริงที่เกิดภายหลัง | `develop` | เจ้าของฟีเจอร์ช่วยตรวจ defect/ผลทดสอบ แล้ว merge หลังผ่าน |

เจ้าของ PR แต่ละคนตรวจและรับผิดชอบงานที่ส่งจริง ระบุการช่วยกันทำตามจริง อย่าแก้ชื่อผู้เขียนหรือเวลาเพื่อสื่อประวัติการทำงานที่ไม่ตรงจริง การกด push ไม่ได้เปลี่ยน author ของ commit

Piyapon แบ่ง commit เป็น production backend และ regression tests ได้ แต่ต้องอยู่ใน PR เดียวกันเพื่อให้ compile/test ได้ครบ Yoko แบ่งตามกลุ่มไฟล์ UI ได้ แต่ไฟล์ร่วม เช่น `friend.js`, `room.js` และ templates ให้รวมโดยคนเดียวก่อน แพ็กเกจแยกตามชั้นงาน ไม่ใช่ patch เทียบ branch จึงอาจมีไฟล์ที่ไม่ได้เปลี่ยนจาก branch ของเพื่อน ต้องตรวจ diff และรักษางานที่ใหม่กว่าของเพื่อนก่อน commit

## เริ่มในเครื่องของเจ้าของ PR แต่ละคน

เปิด Git Bash ที่โฟลเดอร์ repository ของตัวเอง กำหนดค่าตามแถวในตาราง ตัวอย่าง Piyapon:

```bash
branch=piyapon_673380050-9_01
package=01-piyapon-backend
# เปลี่ยนเป็นพาธ repository จริงของเครื่องนี้
cd /c/path/to/CPFriendFinder
git status --short
```

ถ้ามีงานค้าง ให้จัดการงานของตัวเองให้เรียบร้อยก่อน ไม่ใช้ reset/clean ทิ้งงาน จากนั้น:

```bash
git fetch origin
git switch "$branch"
# ถ้ายังไม่มี local branch ให้ใช้แทนคำสั่ง switch ด้านบน:
# git switch --track "origin/$branch"
git pull --ff-only origin "$branch"
git merge origin/develop
```

ถ้าเกิด conflict ให้แก้และตรวจให้เรียบร้อยก่อนนำ ZIP มาทับ ห้ามแทนไฟล์ใหม่กว่าของเพื่อนด้วยสำเนานี้โดยไม่ตรวจ เริ่มขั้นนี้ของ Yoko หลัง PR ของ Piyapon merge แล้ว และของ Apiwich หลัง PR ของ Yoko merge แล้ว

## สำรองแล้วนำไฟล์ชุดของตัวเองเข้า

ดาวน์โหลด ZIP ที่ตรงกับ `package` ไปที่ Downloads:

```bash
stage=$(mktemp -d)
unzip "$HOME/Downloads/$package.zip" -d "$stage"
backup="$HOME/cpfriendfinder-backups/$package-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup"
while IFS= read -r -d '' file; do
  rel=${file#"$stage/"}
  mkdir -p "$(dirname "$rel")"
  if [ -f "$rel" ]; then
    mkdir -p "$backup/$(dirname "$rel")"
    cp -p -- "$rel" "$backup/$rel" || break
  fi
  cp -p -- "$file" "$rel" || break
done < <(find "$stage" -type f -print0)
git status --short
git diff --stat
git diff
```

ถ้า copy มี error ให้หยุดแก้ก่อน ไม่ไป commit คำสั่งนี้ไม่ลบไฟล์ที่มีเฉพาะในเครื่องปลายทาง สำเนา ZIP ระบุไฟล์ที่ควรลบจาก branch ไม่ได้ จึงต้องตรวจ diff ด้วยตัวเอง ไฟล์ที่ไม่เปลี่ยนจะไม่เกิด diff

## Stage และ commit เฉพาะชุดที่รับผิดชอบ

Piyapon:

```bash
./mvnw -Dtest=ProfileSummaryControllerTest,ImageContentStrategyTest,ChatMessageServiceTest,FriendRequestServiceTest,UserControllerMvcTest,ProfileGalleryTest test
git add -- src/main/java src/test/java
git diff --cached --check
git diff --cached
git commit -m "fix: integrate chat profiles and backend regression coverage"
git push origin piyapon_673380050-9_01
```

Yoko:

```bash
git add -- src/main/resources/static src/main/resources/templates
git diff --cached --check
git diff --cached
git commit -m "fix: send chat images and refresh profile relationship state"
git push origin Yoko_673380302-8_01
```

Apiwich:

```bash
git add -- server.js cloudflare-turn.js turn-config.js turn-check.html start-sharing.ps1 .env.example
git add -- docs/public-setup.md docs/cloudflare-turn-setup.md docs/turn-setup.md docs/screen-sharing.md
git diff --cached --check
git diff --cached
git commit -m "feat: integrate gateway and TURN deployment setup"
git push origin apiwich_673380517-7_01
```

หลัง push เปิด PR ด้วยต้นทางตามตารางและ **base = develop** ระบุส่วนที่แก้ ผลที่รันจริง และข้อจำกัดของการทดสอบ ผู้ตรวจตรวจ diff และผลก่อน merge ห้าม deploy ระหว่าง backend/frontend ยังรวมไม่ครบ

หากพบ defect ระหว่างทดสอบ เจ้าของส่วนที่ผิดแก้ใน branch ของตัวเอง แล้วเปิด PR ไป develop ใหม่ เมื่อ merge แล้ว Apiwich deploy ใหม่ จากนั้น Jiratchayaดึง develop และรันซ้ำที่ revision ใหม่ เก็บผลเก่าด้วย ไม่เปลี่ยน Fail เดิมให้ดูเหมือนไม่เคยเกิด

## การตั้งค่า deploy และ key

ไม่มี `application.properties` จริง, `.cloudflare-turn.json`, `.turn-servers.json`, SQL สำรองส่วนตัว, log, `.git`, target หรือ virtual environment อยู่ใน ZIP ต้องใส่ค่าลับผ่าน environment/secret ของโฮสต์หรือไฟล์ส่วนตัวที่ไม่ติดตามด้วย Git อย่าใส่ TURN API Token ใน frontend หรือ PR รูปภาพที่ส่งในแชทเก็บผ่าน object storage เดิม และใช้ gateway ส่ง REST/WebSocket ไป backend เดียวกัน

ตรวจ staged diff ทุกครั้ง ห้าม `git add .` เมื่อมีไฟล์ตั้งค่าส่วนตัว ต้องตรวจโฮสต์รองรับ HTTPS/WebSocket และให้ backend/frontend มาจากชุดที่ merge เดียวกัน ทดสอบสองเครื่องจริงก่อนสรุปผลคอลข้ามเครือข่าย

## Jiratchaya ทดสอบชุดรวมและเก็บผล

หลัง PR 1–3 merge และ Apiwich deploy พร้อมแล้ว ใช้ checkout สะอาด:

```bash
branch=jiratchaya_673380510-1_01
package=04-jiratchaya-tests-docs
# อยู่ที่ repository ของตัวเอง
git status --short
git fetch origin
git switch "$branch"
git pull --ff-only origin "$branch"
git merge origin/develop
```

นำ ZIP 04 เข้าตามขั้นสำรองข้างบนก่อนรัน ชุดนี้ไม่ใส่ Excel มาให้ทับ เก็บ workbook เดิม `test/test-cases/CPFriendFinder_TestCases.xlsx` ไว้ หากเครื่องนี้ไม่มีให้ดึงไฟล์ที่ทีมใช้จริงจาก develop

ใช้ virtual environment เดิม ถ้ายังไม่มีให้ตั้งครั้งเดียว:

```bash
python -m venv .venv-robot
./.venv-robot/Scripts/python.exe -m pip install robotframework robotframework-browser
./.venv-robot/Scripts/python.exe -m Browser.entry init chromium
```

ทดสอบเว็บที่มาจาก revision ที่ merge แล้ว ไม่ใช้ process เก่าที่รันจากสำเนานอก checkout เป็นหลักฐานว่าโค้ด merge ผ่าน ตัวอย่างเมื่อระบบใหม่พร้อมที่ localhost:3000:

```bash
export PYTHONUTF8=1
run=$(date +%Y%m%d-%H%M%S)
results="test/e2e/robot/results/$run"
mkdir -p "$results"
git rev-parse HEAD > "$results/revision.txt"
./.venv-robot/Scripts/python.exe -m pip freeze > "$results/dependencies.txt"
./.venv-robot/Scripts/python.exe -m robot \
  --variable BASE_URL:http://localhost:3000 \
  --outputdir "$results" \
  test/e2e/robot/tests
status=$?
printf 'Robot exit code: %s\n' "$status"
```

หากทดสอบ deploy ให้เปลี่ยน BASE_URL เป็น URL ของชุด deploy นั้น เก็บวันเวลา/URL/revision เดียวกันทุกผล ส่ง `output.xml`, `log.html`, `report.html`, revision และภาพเมื่อ Fail ให้ผู้ช่วยทางส่วนตัว รายงานอาจมีรหัสผ่านบัญชีเทสหรือข้อมูล session จึงต้องตรวจและปิดข้อมูลลับก่อนเผยแพร่

Robot เดิมมีเพียง 5 กรณีด้าน login/register/interests ไม่ครอบคลุมคอลหรือการแก้รอบใหม่ และกรณี interests ตรวจว่ามีอย่างน้อยหนึ่งรายการ ไม่ได้ยืนยันชื่อที่เลือกตรงทุกตัว ต้องมีผลเพิ่มสำหรับ: โปรไฟล์ห้องแสดงความสนใจล่าสุด; self edit; pending/incoming/accept; ส่งข้อความแล้วช่องล้างทันที; ส่งล้มเหลวไม่ทับ draft ใหม่; ส่งรูปสองบัญชีทั้ง room/friend; friend reload แล้วยังเห็นรูป; ห้องกลุ่มไม่แสดงประวัติหลังกลับเข้า; realtime; voice/video/screen share สองเครื่องจริง ยังไม่มีการรัน Robot รอบนี้

การสมัครสองกรณีสร้างบัญชี Tester จริง อย่าลบทิ้งก่อนเก็บหลักฐานและตกลง cleanup รอบใหม่ ไม่ใช้ผลจาก fixture browser แทนผล Robot/สองเครื่องจริง

หลังได้ผลจริง ผู้ช่วยจะเติมเฉพาะข้อมูลผลทดสอบลง Excel เดิม รักษา sheets/columns/styles/formulas และข้อมูลเดิม ส่วน README สรุปตามผลจริงเท่านั้น จากนั้น:

```bash
git add -- test/e2e/robot/tests test/e2e/robot/resources
git add -- test/README.md test/test-plan/test-plan.md test/test-cases/CPFriendFinder_TestCases.xlsx
# เลือกเพิ่มเฉพาะเอกสารผลทดสอบที่ตรวจแล้ว ไม่มี key/ข้อมูลส่วนตัว
# git add -- docs/chat-consistency-and-team-flow.md
git diff --cached --stat
git diff --cached --check
git diff --cached
git commit -m "test: record integrated E2E results"
git push origin jiratchaya_673380510-1_01
```

เปิด PR สุดท้ายจาก Jiratchaya ไป develop ให้เจ้าของฟีเจอร์ตรวจผลก่อน merge ไม่ commit raw report ที่มี credential เมื่อรวมแล้วทุกคนดึง develop; Apiwichยืนยัน deploy revision สุดท้าย การนำ develop เข้า main ทำเมื่อทีมอนุมัติ release จริง ไม่ทำอัตโนมัติในรอบนี้
