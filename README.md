<div dir="rtl">

# Claude RTL Helper - עברית מימין לשמאל ב-Claude Desktop

תיבת ההקלדה של אפליקציית Claude Desktop בווינדוס נעולה על כיוון שמאל-לימין (LTR). כשמקלידים עברית, סימני הפיסוק קופצים לצד הלא נכון וטקסט מעורב (עברית + מספרים או אנגלית) מתערבב.

הכלי הזה הוא סקריפט AutoHotkey קטן וקריא שפותר את זה ברמת המקלדת: בכל פעם שמתחילים הודעה חדשה בקלוד, הוא שותל תו יוניקוד בלתי-נראה אחד (U+202B, RIGHT-TO-LEFT EMBEDDING) בתחילת השורה, והעברית מוצגת כמו שצריך - מימין לשמאל.

![לפני ואחרי](before-after.png)

צילום אמיתי מתוך Claude Desktop, אותו משפט בדיוק בשני המקרים.

**עקרונות התכנון:**

- **שקוף וניתן לביקורת** - קובץ טקסט אחד, בלי קבצים מקומפלים, בלי רשת, בלי לוגים.
- **לא נוגע באפליקציה** - שום שינוי בקבצי Claude Desktop. עדכוני האפליקציה לא שוברים אותו, והוא לא שובר אותם.
- **נכשל בבטחה** - אם אנת'רופיק ישנו משהו, הסקריפט לכל היותר יפסיק לעזור. מקשי ה-Enter מוגדרים במצב pass-through, כך שהסקריפט מבחינה מבנית לא מסוגל לחסום שליחת הודעה.

## התקנה (3 צעדים, בלי הרשאות אדמין)

1. **התקנת AutoHotkey v2** (סביבת ההרצה, קוד פתוח). בטרמינל:

<div dir="ltr">

```
winget install AutoHotkey.AutoHotkey --version 2.0.26 --scope user
```

</div>

   אם הפקודה `winget` לא מזוהה - התקינו "App Installer" מחנות מיקרוסופט, או השתמשו באפשרות הניידת למטה.

2. **הורדת** `claude-rtl.ahk` מהמאגר הזה. לחיצה כפולה מפעילה אותו - יופיע אייקון ירוק של AutoHotkey במגש המערכת (ליד השעון).

3. **הפעלה אוטומטית עם ווינדוס** (רשות): מקישים Win+R, מקלידים `shell:startup`, ומעתיקים את `claude-rtl.ahk` (או קיצור דרך אליו) לתיקייה שנפתחה.

**אפשרות ניידת (בלי התקנה כלל):** מורידים את ה-zip הרשמי [AutoHotkey_2.0.26.zip](https://github.com/AutoHotkey/AutoHotkey/releases/tag/v2.0.26), מחלצים, ומריצים: `AutoHotkey64.exe claude-rtl.ahk`

**הסרה:** מוחקים את הקובץ מ-`shell:startup` (ואם רוצים - `winget uninstall AutoHotkey.AutoHotkey`). זה הכל. הסקריפט לא נוגע בשום דבר אחר במחשב.

## שימוש

ברוב המקרים אין מה לעשות. הזריעה האוטומטית קורית בארבעה מצבים: בפתיחת חלון קלוד (פעם אחת לכל חלון), אחרי כל שליחת הודעה ב-Enter, אחרי ירידת שורה (Shift+Enter), ובפתיחת צ'אט חדש (Ctrl+N). בנוסף, אם ההודעה הנוכחית עדיין לא נזרעה - מעבר פריסת מקלדת לעברית משלים את הזריעה. הזריעה האוטומטית פועלת **רק כשפריסת המקלדת עברית** - הודעות באנגלית נשארות נקיות לגמרי.

הזריעה מחדש אחרי כל ירידת שורה היא קריטית ולא קוסמטית: כל שבירת שורה פותחת פסקה חדשה מבחינת אלגוריתם הכיווניות של יוניקוד, ותו הכיוון לא חוצה גבול פסקה. בלי זריעה מחדש, השורה הראשונה נראית מושלמת וכל שורה אחריה חוזרת להיות שבורה - זה נבדק בפועל מול האפליקציה.

| קיצור | פעולה |
|---|---|
| Ctrl+Alt+J | שתילת תו RTL ידנית בנקודת הסמן (תיקון מיידי; עובד רק בחלון הראשי של קלוד, גם כשהזריעה כבויה או שהפריסה אנגלית) |
| Ctrl+Alt+Shift+R | הדלקה/כיבוי של הזריעה האוטומטית (גלובלי; המצב מוצג במגש המערכת) |

## מגבלות ידועות

- **הסדר נכון, היישור לא.** זו המגבלה המהותית, והיא נמדדה: הרצנו את אותם משפטים מעורבים בכרומיום ומדדנו את המיקום של כל תו בנפרד. סדר התווים עם הזריעה **זהה תו-בתו** לאלמנט RTL אמיתי - מקפים, פסיקים, נקודה סופית, סוגריים, מספרים ותאריכים כולם במקום הנכון. מה שנשאר שונה הוא היישור בלבד: הטקסט צמוד לשוליים השמאליים במקום לימניים. בהודעה קצרה זה כמעט לא מורגש; בפסקה ארוכה שנשברת לכמה שורות זה מורגש, כי השורה האחרונה יושבת בצד שמאל. יישור הוא תכונת CSS ושום תו יוניקוד לא יכול לשנות אותו - זו תקרה מובנית של כל פתרון מבוסס מקלדת, ולא באג.
- **התו נשלח עם ההודעה.** התו הבלתי-נראה הוא חלק מהטקסט שנשלח לקלוד (אין לו השפעה מעשית על התשובות - זהו תו כיווניות סטנדרטי שמודלים פוגשים כל הזמן בטקסט RTL), והוא נשאר בטקסט גם כשמעתיקים אותו למקום אחר. **חשוב למשפטנים ולמתכנתים:** אם מעתיקים טקסט מהודעה לתוך מסמך משפטי או לקוד - מומלץ להדביק דרך "הדבקה ללא עיצוב" או להסיר את התו; תווי כיוון בלתי-נראים יכולים לשנות סדר תצוגה של טקסט סמוך במסמך היעד, ו-GitHub וכלי פיתוח מסמנים אותם באזהרה.
- **פעולות עכבר לא מפעילות זריעה** - מעבר לשיחה אחרת בסרגל הצד, פתיחת צ'אט חדש בלחיצה על "New", או שליחה בלחיצה על כפתור השליחה. הסקריפט מזהה מקלדת בלבד, וכותרת החלון של קלוד לא משתנה בין שיחות כך שאין לו דרך לדעת. הפתרון: Ctrl+Alt+J פעם אחת, או פשוט לשלוח את ההודעה הבאה עם Enter והזריעה חוזרת מעצמה.
- **מחיקת הטיוטה מוחקת גם את התו** (Ctrl+A והקלדה מחדש, או Backspace בתחילת השורה), והסקריפט לא יודע על כך. אם התצוגה "התקלקלה פתאום" באמצע כתיבה - Ctrl+Alt+J מתקן מיד.
- **זריעה לתוך טיוטה קיימת מזיזה את הסמן לסוף.** במקרים שבהם תו נזרע כשכבר יש טקסט בתיבה (למשל הפעלת הסקריפט כשטיוטה פתוחה, מעבר לעברית באמצע טיוטה שלא נזרעה, או טיוטה ששוחזרה אחרי הפעלה מחדש של קלוד) - הסמן קופץ לסוף ההודעה. אם ערכתם באמצע המשפט, חזרו לנקודה עם העכבר.
- **בחירת פקודת slash או mention עם Enter** נספרת אצל הסקריפט כשליחת הודעה (הוא לא רואה את התפריט הקופץ). התוצאה: תו נוסף עשוי להיזרע לטיוטה והסמן יקפוץ לסוף. הנזק חד-פעמי ומתאפס בשליחה האמיתית הבאה.
- **פקודות עם `/`:** אם מקלידים `/` בשורה שכבר נזרעה, הלוכסן עלול להופיע ויזואלית בצד הלא נכון. Backspace אחד לפני הקלדת הפקודה פותר. אותו עניין לשורה שמתחילה בספרה (למשל רשימה ממוספרת אחרי Shift+Enter מהיר) - הספרה עלולה להישאר מחוץ לזריעה.
- **שדות אחרים בחלון קלוד:** הסקריפט מזהה את חלון קלוד ואת פריסת המקלדת, אבל לא יודע איזה שדה בתוך החלון מחזיק פוקוס. אם הפוקוס בשדה אחר (למשל תיבת החיפוש) ברגע זריעה - Enter, Shift+Enter, מעבר לעברית או פתיחת חלון - תו בודד עלול להישתל שם והחיפוש יפסיק להתאים בשקט. לניקוי: Ctrl+A ואז Delete בשדה (Backspace לבדו מוחק את התו הגלוי האחרון, לא את הבלתי-נראה שבתחילת השדה).
- **אם קלוד רץ כמנהל (אדמין)** והסקריפט לא - ווינדוס חוסמת את ההזרקה (UIPI) והסקריפט פשוט לא יעבוד. מריצים את שניהם כמשתמש רגיל.

## אבטחה ופרטיות

הכלי הזה נכתב מתוך הנחה שתרצו לוודא בעצמכם שהוא בטוח. לכן הוא מופץ כקוד מקור קריא בלבד - לא כקובץ הרצה מקומפל - וכל הקוד הוא כ-220 שורות (רובן הערות תיעוד) בקובץ אחד.

**מה הוא עושה, במדויק:** כשחלון קלוד הראשי פעיל, הוא מקליד תו יוניקוד בלתי-נראה אחד לתיבת הקלט, יחד עם מקשי ניווט (Ctrl+Home ו-Ctrl+End) שמחזירים את הסמן למקומו. זה כל מה שהוא מקליד אי-פעם, והוא מכוון רק לחלון הראשי של קלוד - דיאלוגים מקומיים (כמו בוחר הקבצים) מסוננים לפי window class. כל מסלולי הזריעה האוטומטיים בודקים מחדש ברגע הביצוע שחלון קלוד הראשי פעיל ושפריסת המקלדת עברית; החשיפה שנותרה היא מילישניות בודדות של רצף ההקלדה עצמו.

**ה-keyboard hook, בלי יפיוף:** כדי לזהות Enter בתוך קלוד, הסקריפט משתמש ב-hook מקלדת סטנדרטי של ווינדוס - אותו מנגנון שמשמש כל כלי קיצורי-דרך, קורא-מסך ומרחיב-טקסט. ליתר דיוק:

- ה-hook הוא מערכתי מעצם התכנון של ווינדוס; אי אפשר להתקין אותו "רק לאפליקציה אחת". קוד המקש של כל הקשה עובר דרכו.
- הפעולה היחידה על כל אירוע: השוואה מול רשימת הקיצורים הרשומים. כל השאר עובר הלאה ללא שינוי ואינו נשמר בשום מקום. השורות `KeyHistory 0` ו-`ListLines 0` בסקריפט מנטרלות גם את תצוגת המקשים האחרונים ואת יומן השורות המובנים של AutoHotkey, כך ששום הקשה ושום עקבת ריצה לא נשמרות אפילו בזיכרון.
- ה-hook לא רואה מסכי UAC, מסך התחברות, או קלט לחלונות מוגבהים (אדמין).
- שום דבר לא נכתב לדיסק ולא נשלח לשום מקום.

**בדיקה עצמית של הקוד (Ctrl+F בקובץ):**

- `Download`,‎ `FileOpen`,‎ `FileAppend`,‎ `A_Clipboard` - לא מופיעים בקוד בכלל: אין רשת, אין קבצים, אין גישה ל-clipboard.
- המילה Run על הטיותיה אינה מופיעה בקוד - אין הרצת תהליכים.
- `DllCall` מופיע פעמיים בדיוק - `GetWindowThreadProcessId` ו-`GetKeyboardLayout`, שתיהן לזיהוי פריסת המקלדת. כל `DllCall` אחר בקובץ הוא דגל אדום.
- אין בקובץ אף תו בלתי-נראה - התו נבנה בקוד כ-`Chr(0x202B)` והמקור כולו ASCII גלוי.

**אימות שרשרת האספקה (5 דקות):**

1. קראו את הסקריפט. קובץ אחד, בלי includes.
2. התקינו את AutoHotkey רק מהמקור הרשמי, בגרסה הנעוצה שבפקודת ההתקנה למעלה (2.0.26). פקודת winget מאמתת את ה-hash אוטומטית מול ה-manifest של מיקרוסופט. ידנית: `Get-FileHash AutoHotkey_2.0.26_setup.exe` חייב להחזיר `2BF1B89B1047136490FC321D2FDC988B42DD86F693EEA7872746AC6ADF722BC3` (ה-hash תקף לגרסה 2.0.26 בלבד; לגרסה אחרת בדקו מול ה-manifest שלה).
3. שימו לב: הבינארים של AutoHotkey הם קוד פתוח אבל **לא חתומים דיגיטלית**. האמון מגיע מבדיקת ה-hash, לא מתעודה. במחשבים עם Smart App Control הם רצים על סמך מוניטין הענן של מיקרוסופט (נבדק בפועל על מחשב עם SAC במצב אכיפה).
4. מומלץ: חסמו ל-`AutoHotkey64.exe` גישה לרשת ב-Windows Firewall. הכלי לא צריך רשת בכלל ועובד מלא במצב לא-מקוון; ל-AutoHotkey אין טלמטריה ואין עדכונים אוטומטיים.

**למנהלי IT:** הכלי רץ כולו במרחב המשתמש - התקנה per-user, בלי אדמין, בלי services, בלי drivers, בלי persistence מעבר לקיצור בתיקיית Startup שהמשתמש יוצר בעצמו. מכיוון ש-AutoHotkey לא חתום, בסביבות WDAC/AppLocker אין אפשרות ל-publisher rule - יש לאשר לפי hash (הערך למעלה) או לפי נתיב ההתקנה. שטח ההתנהגות הרלוונטי ל-EDR: hook מקלדת (WH_KEYBOARD_LL), הזרקת SendInput של תו יוניקוד אחד בתוספת מקשי ניווט (Ctrl+Home / Ctrl+End) לחלון הקדמי כשהוא החלון הראשי של Claude.exe, ושתי קריאות DllCall לזיהוי פריסת מקלדת. זה כל שטח ההתנהגות.

## עמידות לעדכוני Claude Desktop

הסקריפט תלוי בשלושה דברים בלבד: שם התהליך (`Claude.exe`), ה-window class הסטנדרטי של חלון Chromium ראשי, וזה שתיבת הקלט מקבלת קלט מקלדת רגיל. הוא לא קורא שום דבר מהאפליקציה - לא DOM, לא קבצים - ולכן עדכוני גרסה שוטפים לא נוגעים בו.

- **למה לא "לתקן" את האפליקציה עצמה?** קיים כלי קהילתי שמפטצ' את קבצי האפליקציה (asar) להוספת RTL מלא. הבעיה: Claude Desktop מאמת את שלמות הקבצים (ה-hash של ה-asar שמור בתוך `claude.exe`), כך שפטצ' כזה דורש עקיפת אימות + תעודה עצמית ב-root store + הרצה מחדש אחרי כל עדכון. בחרנו בכוונה בגישה שלא נוגעת באפליקציה בכלל.
- **תרחישי שבירה אפשריים:** שינוי שם התהליך (תיקון של שורה אחת) או סינון תווי bidi בתיבת הקלט (הסקריפט פשוט יפסיק להשפיע). בכל התרחישים המצב הוא "מפסיק לעזור", אף פעם לא "חוסם את קלוד".
- **תוכנית פרישה:** ברגע שאנת'רופיק יוסיפו תמיכת RTL מובנית לתיבת הקלט - פשוט מוחקים את הסקריפט. עד אז אפשר לעקוב אחרי [issue #38005](https://github.com/anthropics/claude-code/issues/38005) (או כל issue עדכני אחר על תמיכת RTL - הבקשות מאוחדות מעת לעת). התו הזרוע לא מתנגש עם RTL מובנה אם וכשיגיע.
- **חלופה בדפדפן:** בסביבה שבה אי אפשר להריץ AutoHotkey (מחשב ארגוני נעול), אפשר לעבוד עם claude.ai בדפדפן בתוספת הרחבת RTL.

## אפליקציות אחרות

הכלי מכוון ל-Claude Desktop בלבד, וזו החלטה מבוססת בדיקה ולא הנחה. בדקנו את אפליקציית ChatGPT לשולחן העבודה (חבילת OpenAI.Codex בווינדוס) עם אותו משפט מעורב בדיוק ובלי שום תו זריעה: **היא מציגה עברית נכון מלכתחילה, כולל יישור לימין.** אין שם מה לתקן, והפעלת הכלי הזה עליה רק תוסיף תו מיותר לטקסט. אם יום אחד זה ישתנה, ההתאמה היא שינוי של מחרוזת אחת בסקריפט - שם התהליך.

## רישיון

MIT. ראו [LICENSE](LICENSE).

</div>

---

# Claude RTL Helper (English)

![Before and after](before-after.png)

The Claude Desktop (Windows) message box is locked to left-to-right, which breaks Hebrew typing - punctuation lands on the wrong side and mixed Hebrew/Latin/number runs reorder. This single-file AutoHotkey v2 script (~220 lines, mostly documentation comments) fixes it at the keyboard level: whenever a new message starts, it seeds one invisible Unicode character (U+202B, RIGHT-TO-LEFT EMBEDDING) at the start of the input - and only while the active keyboard layout is Hebrew, so English messages are never touched.

**Design principles:** auditable (one readable ASCII text file, no compiled binaries, no network, no logging), app-independent (never modifies Claude's files, so app auto-updates cannot break it and it cannot break them), and fail-safe (all Enter hotkeys are pass-through - the script structurally cannot block sending a message; if Anthropic changes anything, it degrades to a silent no-op).

**Install (no admin):** `winget install AutoHotkey.AutoHotkey --version 2.0.26 --scope user`, download `claude-rtl.ahk`, double-click it. Optional autostart: copy it into `shell:startup`. Portable option: official AutoHotkey zip, `AutoHotkey64.exe claude-rtl.ahk`. Uninstall: delete the file - nothing else was touched.

**Hotkeys:** Ctrl+Alt+J inserts the RTL character manually (Claude window only). Ctrl+Alt+Shift+R toggles automatic seeding (global, state shown in the tray).

**Security summary:** the script types exactly one invisible character plus caret-restoring navigation keys (Ctrl+Home / Ctrl+End), aimed only at Claude's main window (native dialogs are filtered out by window class), with every scheduled seed re-checking its conditions at the moment it fires. Like every hotkey utility it uses a standard Windows low-level keyboard hook; each key event is only compared against the registered hotkeys, and nothing is stored (`KeyHistory 0`, `ListLines 0`), logged, or transmitted. Self-audit with Ctrl+F: `Download`, `FileOpen`, `FileAppend`, `A_Clipboard` and the word Run in any form do not appear in the source; `DllCall` appears exactly twice (GetWindowThreadProcessId, GetKeyboardLayout - keyboard-layout detection); the source is pure visible ASCII (the seed is built as `Chr(0x202B)`). AutoHotkey's official binaries are open-source but unsigned: install the pinned v2.0.26 and verify SHA256 `2BF1B89B1047136490FC321D2FDC988B42DD86F693EEA7872746AC6ADF722BC3` (winget verifies it for you; the hash is valid for 2.0.26 only). Recommended: firewall-block AutoHotkey64.exe outbound - the tool is fully offline. For WDAC/AppLocker estates, allow the interpreter by hash; the EDR-relevant surface is exactly a WH_KEYBOARD_LL hook, SendInput of one Unicode character plus the two navigation chords, and the two DllCalls above.

**Known limitations:** run order is fixed but alignment stays left (only in-app CSS could change anchoring - deliberately out of scope); the invisible character travels with your message and survives copy-paste (strip it before pasting into legal documents or code); switching chats or sending with the mouse doesn't trigger reseeding (press Ctrl+Alt+J once, or the next Enter restores it); heavy edits can delete the seed (Ctrl+Alt+J recovers); a seed landing in an existing draft (script started over an open draft, or a draft restored after an app relaunch) moves the caret to the end; picking a slash-command or mention with Enter counts as a send, so one extra character may be seeded into the draft - self-resets on the next real send; if focus is in a non-input field of the Claude window (e.g. search) at seed time, a single character may land there - clear with Ctrl+A then Delete; if Claude runs elevated and the script doesn't, Windows UIPI silently blocks injection - run both unelevated.

**Sunset plan:** when Claude Desktop ships native RTL input (track [anthropics/claude-code#38005](https://github.com/anthropics/claude-code/issues/38005) or whichever issue the requests get consolidated into), delete the script - there is nothing else to uninstall.

MIT License.
