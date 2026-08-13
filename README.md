<div dir="rtl">

# Claude RTL Helper - עברית מימין לשמאל בתיבת ההקלדה של Claude Desktop

> פרויקט קהילתי עצמאי. אינו מסונף ל-Anthropic, אינו מקבל ממנה חסות ואינו נתמך על ידה. Claude ו-Anthropic הם סימני מסחר של Anthropic PBC ומוזכרים כאן לזיהוי המוצר שאיתו הכלי עובד בלבד.
>
> נבדק מול Claude Desktop בווינדוס 11, אוגוסט 2026. אנת'רופיק כבר הוסיפו רינדור RTL מובנה בלשונית Code, והקוד ללשונית Chat קיים באפליקציה אך מושבת - ייתכן שהכלי הזה יתייתר בהמשך. תיבת ההקלדה עדיין LTR, וזה בדיוק הפער שהוא סוגר.

תיבת ההקלדה של אפליקציית Claude Desktop בווינדוס נעולה על כיוון שמאל-לימין (LTR). כשמקלידים עברית, סימני הפיסוק קופצים לצד הלא נכון וטקסט מעורב (עברית + מספרים או אנגלית) מתערבב.

הכלי הזה הוא סקריפט AutoHotkey קטן וקריא שפותר את זה ברמת המקלדת: בכל פעם שמתחילים הודעה חדשה בקלוד, הוא שותל תו יוניקוד בלתי-נראה אחד (U+202B, RIGHT-TO-LEFT EMBEDDING) בתחילת השורה, והעברית מוצגת **בסדר הנכון** - מימין לשמאל. היישור עצמו נשאר שמאלי; ראו "מגבלות ידועות".

**הכלי משפיע רק על מה שאתם מקלידים בתיבת ההודעה.** תשובות של קלוד ממשיכות להיות מוצגות בדיוק כפי שהאפליקציה מציגה אותן.

![לפני ואחרי](before-after.png)

צילום אמיתי מתוך Claude Desktop, אותו משפט בדיוק בשני המקרים.

**עקרונות התכנון:**

- **שקוף וניתן לביקורת** - קובץ טקסט אחד, בלי קבצים מקומפלים, בלי רשת, בלי לוגים.
- **לא נוגע באפליקציה** - שום שינוי בקבצי Claude Desktop.
- **נכשל בבטחה** - הוא לא יכול לשבור כלום במחשב שלכם. עדכון של האפליקציה יכול לגרום לו להפסיק לעזור, למשל אם שם התהליך ישתנה, אבל אף פעם לא להשאיר משהו שבור. מקשי ה-Enter מוגדרים במצב pass-through, כך שהסקריפט מבחינה מבנית לא מסוגל לחסום שליחת הודעה.

## התקנה (3 צעדים; במחשב נקי - בלי הרשאות אדמין)

1. **התקנת AutoHotkey v2** (סביבת ההרצה, קוד פתוח). פתחו טרמינל **רגיל, לא "הפעל כמנהל"** (Win+X ואז Terminal), והריצו:

<div dir="ltr">

```
winget install AutoHotkey.AutoHotkey --version 2.0.26 --scope user
```

</div>

   מתקין AutoHotkey קובע בעצמו לאן להתקין, לפי זה שהטרמינל מוגבה או לא - טרמינל מוגבה יתקין לכל המשתמשים גם עם `--scope user`. לאימות: `winget list --id AutoHotkey.AutoHotkey` צריך להראות התקנת משתמש. אם AutoHotkey כבר מותקן במחשב עבור כל המשתמשים, עשויה להופיע בקשת אישור מנהל; אפשר לבטל אותה וההתקנה תמשיך כהתקנת משתמש.

   אם `winget` לא מזוהה - התקינו "App Installer" מחנות מיקרוסופט, או השתמשו באפשרות הניידת למטה.

2. **הורידו את [`claude-rtl.ahk`](https://github.com/legalmindcode/legalmind-claude-desktop-rtl/raw/v1.1.0/claude-rtl.ahk)** (קישור ישיר לקובץ מהגרסה המתויגת). אל תעתיקו את הקוד ל-Notepad - הוא יישמר כ-`.txt` ולא יעבוד. לחיצה כפולה על הקובץ מפעילה אותו, ואייקון של AutoHotkey מופיע במגש המערכת; בווינדוס 11 אייקונים חדשים מוסתרים מאחורי החץ למעלה.

   **בדיקה שזה עובד:** עברו לעברית, ובתיבת ההודעה של קלוד הקלידו משפט שמסתיים בנקודה. הנקודה צריכה להופיע בצד שמאל של המשפט. באנגלית הכלי אינרטי לחלוטין, ולכן "לא קורה כלום" באנגלית אינו סימן לכשל. והנקודה נשארה בצד ימין? Ctrl+Alt+J זורע ידנית, ואם גם זה לא שינה - ודאו שאייקון AutoHotkey אכן מופיע במגש.

3. **הפעלה אוטומטית עם ווינדוס** (רשות): Win+R, מקלידים `shell:startup`, ובתיקייה שנפתחה יוצרים **קיצור דרך** לקובץ - לא מעתיקים את הקובץ עצמו, כדי שיישאר עותק אחד לעדכן.

**אפשרות ניידת (בלי התקנה כלל):** מורידים את ה-zip הרשמי [AutoHotkey_2.0.26.zip](https://github.com/AutoHotkey/AutoHotkey/releases/tag/v2.0.26), מחלצים, וגוררים את `claude-rtl.ahk` על `AutoHotkey64.exe`. שימו לב: באפשרות הזו אין שיוך לסיומת `.ahk`, ולכן להפעלה אוטומטית קיצור הדרך בתיקיית ה-Startup חייב להצביע על `AutoHotkey64.exe` עם נתיב הסקריפט כפרמטר.

**אם מותקן אצלכם גם AutoHotkey v1:** קבצי `.ahk` עלולים להיפתח איתו והסקריפט ייכשל עם הודעת שגיאה. פתרו בקליק ימני על הקובץ, "פתח באמצעות", ובחירה ב-AutoHotkey v2.

**הסרה:** מוחקים את קיצור הדרך מ-`shell:startup` וסוגרים את הסקריפט מאייקון המגש. אם רוצים גם להסיר את סביבת ההרצה: `winget uninstall AutoHotkey.AutoHotkey`.

## שימוש

**כלל אצבע אחד מכסה את כל המצבים: ראיתם שה-RTL לא נכנס והעברית יצאה שבורה? לחצו Ctrl+Alt+J פעם אחת - וזה מסודר.** כל השאר בסעיף הזה קורה מעצמו.

ברוב המקרים אין מה לעשות. הזריעה האוטומטית קורית בחמישה מצבים: בפתיחת חלון קלוד, בכל חזרה לפוקוס על קלוד ממקום אחר (מוגבל לפעם ב-5 שניות), אחרי כל שליחת הודעה ב-Enter, אחרי ירידת שורה (Shift+Enter), ובפתיחת צ'אט חדש (Ctrl+N). בנוסף, אם ההודעה הנוכחית עדיין לא נזרעה, מעבר פריסת מקלדת לעברית משלים את הזריעה.

**כמה מהר זה תופס:** הזריעה אסינכרונית - היא רצה על טיימרים קצרים, לא ברגע האירוע עצמו:

- המספר שחשוב ברוב המקרים - הפעלת הסקריפט עם טיוטה פתוחה או חזרה לחלון קלוד: התו נזרע בתוך פחות משנייה (כ-0.6 שניות). אחרי שליחה ב-Enter: כרבע שנייה. אחרי Shift+Enter: מיידי בפועל (60 מילישניות). אחרי Ctrl+N: כחצי שנייה, כדי לתת לתיבת הצ'אט החדש להיטען.
- הזריעה בתחילת הודעה מחכה בכוונה להפסקה של רבע שנייה בהקלדה, כדי שקפיצת הסמן (Ctrl+Home ו-Ctrl+End) לא תשתלב בין הקשות. בהקלדה רצופה ממש, בלי אף הפסקה של רבע שנייה, היא תמתין להפסקה הראשונה - ולכן הודעה שנכתבת ונשלחת בנשימה אחת עלולה לצאת לא-זרועה. בפועל הפסקה כזו כמעט תמיד קיימת, ו-Ctrl+Alt+J זורע מיד גם באמצע הקלדה.
- חזרה נוספת לפוקוס בתוך 5 שניות מזריעת החזרה הקודמת לא זורעת שוב (מגבלת הקצב שלמעלה). בכל מצב שבו לא רוצים לחכות - Ctrl+Alt+J זורע מיד, תמיד.

**וכמה זה עולה למחשב:** כלום שמורגש. הבודק מתעורר כשלוש פעמים בשנייה לכמה שאילתות חלונות שנמדדות במיקרו-שניות, והזריעה עצמה מקלידה תו בודד רק כשמשהו באמת קרה - שליחה, ירידת שורה, חזרת פוקוס. אין כתיבה לדיסק, אין רשת, ושום דבר לא נצבר בזיכרון. נמדד במכונה אמיתית: כ-15MB זיכרון ועומס מעבד ממוצע של פחות מאחוז בודד מליבה אחת - פחות מלשונית דפדפן רדומה.

הזריעה בחזרה לפוקוס נועדה לכסות את מה שהסקריפט לא יכול לראות - פתיחת שיחה או שליחה בלחיצת עכבר, שמרוקנות את התיבה בלי לירות שום קיצור. היא מתבצעת בנקודת הסמן ובלי להזיז אותו, כדי שטיוטה פתוחה לא תופרע. המחיר: אם חוזרים לטיוטה קיימת, נוסף לה תו בלתי-נראה שאינו משנה דבר בתצוגה אך כן נוסע עם ההודעה.

הזריעה מחדש אחרי כל ירידת שורה היא קריטית ולא קוסמטית: כל שבירת שורה פותחת פסקה חדשה מבחינת אלגוריתם הכיווניות של יוניקוד, ותו הכיוון לא חוצה גבול פסקה. בלי זה, השורה הראשונה נראית מושלמת וכל שורה אחריה חוזרת להיות שבורה.

**מתי כן נזרע תו:** הבדיקה נעשית ברגע הזריעה, לא ברגע השליחה. אם פריסת המקלדת אינה עברית באותו רגע, לא נזרע כלום - ולכן הודעה שנכתבת כולה באנגלית נשארת נקייה. הודעה שהתחילה בעברית ונמשכה באנגלית תישא את התו, וגם Ctrl+Alt+J זורע בלי תלות בפריסה.

| קיצור | פעולה |
|---|---|
| Ctrl+Alt+J | שתילת תו RTL ידנית |
| Ctrl+Alt+Shift+R | הדלקה או כיבוי של הזריעה האוטומטית |

Ctrl+Alt+J מוסיף את התו בנקודת הסמן והוא התיקון המיידי לכל מצב שבו התצוגה התקלקלה. הוא פועל רק בחלון הראשי של קלוד, אך שם הוא פועל תמיד - גם כשהזריעה האוטומטית כבויה וגם כשהפריסה אנגלית. Ctrl+Alt+Shift+R הוא גלובלי, והמצב מוצג במגש המערכת.

## מגבלות ידועות

- **הסדר נכון, היישור לא.** זו המגבלה המהותית, והיא נמדדה: הרצנו את אותם משפטים מעורבים בכרומיום ומדדנו את המיקום של כל תו בנפרד. סדר התווים עם הזריעה **זהה תו-בתו** לאלמנט RTL אמיתי - מקפים, פסיקים, נקודה סופית, סוגריים, מספרים ותאריכים כולם במקום הנכון. מה שנשאר שונה הוא היישור בלבד: הטקסט צמוד לשוליים השמאליים במקום לימניים. בשורה או שתיים בקושי מרגישים; בפסקה ארוכה שנשברת לכמה שורות זה כן מרגיש, כי השורה האחרונה יושבת בצד שמאל. בתיבה שנעולה ל-`direction: ltr` כמו כאן, יישור הוא תכונת CSS ושום תו יוניקוד לא יכול לשנות אותו - זו תקרה מובנית של כל פתרון מבוסס מקלדת, ולא באג.
- **התו נשלח עם ההודעה.** התו הבלתי-נראה הוא חלק מהטקסט שנשלח לקלוד (אין לו השפעה מעשית על התשובות - זהו תו כיווניות סטנדרטי שמודלים פוגשים כל הזמן בטקסט RTL), והוא נשאר בטקסט גם כשמעתיקים אותו למקום אחר. **חשוב למשפטנים ולמתכנתים:** אם מעתיקים טקסט מהודעה לתוך מסמך משפטי או לקוד, מומלץ להדביק דרך "הדבקה ללא עיצוב" או להסיר את התו; תווי כיוון בלתי-נראים יכולים לשנות סדר תצוגה של טקסט סמוך במסמך היעד, ו-GitHub וכלי פיתוח מסמנים אותם באזהרה.
- **פעולות עכבר בתוך החלון אינן מזוהות** - מעבר לשיחה אחרת בסרגל הצד, פתיחת צ'אט חדש בלחיצה, או שליחה בלחיצה על כפתור השליחה. הסקריפט מזהה מקלדת בלבד, וכותרת החלון של קלוד אינה משתנה בין שיחות כך שאין לו אות אחר להישען עליו. מה שכן מכסה חלק גדול מהמקרים: כל חזרה לפוקוס על קלוד מכל מקום אחר מפעילה זריעה. אם בכל זאת יצא שבור - Ctrl+Alt+J פעם אחת מתקן, וגם שליחת ההודעה הבאה עם Enter מחזירה את הזריעה.
- **מחיקה מוחקת גם את התו** - ניקוי כל הטיוטה (Ctrl+A והקלדה מחדש), Backspace בתחילת השורה, וגם מחיקת שורה שלמה אחורה: התו בלתי-נראה, ולכן Backspace אחד בולע אותו בלי שום סימן, והשורה קופצת חזרה ל-LTR. הסקריפט לא יודע על כך. אם התצוגה התקלקלה פתאום באמצע כתיבה או אחרי מחיקה - Ctrl+Alt+J מתקן מיד.
- **זריעה לתוך טיוטה קיימת מזיזה את הסמן לסוף.** קורה כשהסקריפט מופעל כשטיוטה כבר פתוחה, או כשעוברים לעברית באמצע טיוטה שלא נזרעה. אם ערכתם באמצע המשפט, חזרו לנקודה עם העכבר.
- **בחירת פקודת slash או mention עם Enter** נספרת אצל הסקריפט כשליחת הודעה, כי הוא לא רואה את התפריט הקופץ. התוצאה: תו נוסף עשוי להיזרע והסמן יקפוץ לסוף. הנזק חד-פעמי ומתאפס בשליחה האמיתית הבאה.
- **הדבקת טקסט רב-שורתי** מוגנת רק בשורה הראשונה, כי הסקריפט אינו קורא את הלוח ולכן אינו יודע מתי הודבק טקסט.
- **פקודות עם `/` ושורות שמתחילות בספרה:** הלוכסן או הספרה עלולים להופיע ויזואלית בצד הלא נכון. Backspace אחד לפני ההקלדה פותר.
- **שדות אחרים בחלון קלוד:** הסקריפט מזהה את החלון ואת פריסת המקלדת, אבל לא איזה שדה מחזיק פוקוס. אם הפוקוס בשדה אחר, למשל תיבת החיפוש, ברגע זריעה - תו בודד עלול להישתל שם והחיפוש יפסיק להתאים בשקט. לניקוי: Ctrl+A ואז Delete באותו שדה.
- **אם קלוד רץ כמנהל** והסקריפט לא, ווינדוס חוסמת את ההזרקה (UIPI) והסקריפט פשוט לא יעבוד. מריצים את שניהם כמשתמש רגיל.

## אבטחה ופרטיות

הכלי נכתב מתוך הנחה שתרצו לוודא בעצמכם שהוא בטוח. לכן הוא מופץ כקוד מקור קריא בלבד, לא כקובץ הרצה מקומפל: קובץ אחד, 264 שורות - כ-165 שורות קוד והשאר הערות תיעוד וריווח.

**בשורה התחתונה, בלי מונחים:** הכלי לא מקליט את מה שאתם כותבים, לא שומר שום דבר ולא שולח שום דבר לשום מקום - אין לו בכלל יכולת רשת, קבצים או גישה ללוח ההעתקה, ואפשר לוודא זאת בקובץ עצמו ("בדיקה עצמית" למטה). הדבר היחיד שהוא מוסיף הוא תו כיווניות בלתי-נראה אחד בתיבת ההודעה של קלוד, והתו הזה נשלח כחלק מההודעה - מי שמעתיק טקסט מקלוד למסמך משפטי, ראו את האזהרה ב"מגבלות ידועות". ומי שמקליד חומר חסוי צריך לשמוע עובדה אחת במלואה: כמו כל כלי קיצורי מקלדת בווינדוס, הסקריפט נמצא בנתיב של כל הקשה במחשב - ומה שהוא עושה איתה הוא השוואה לרשימת הקיצורים שלו, ותו לא. הפרטים המלאים בהמשך הסעיף.

**מה הוא עושה, במדויק:** כשחלון קלוד הראשי פעיל, הוא מקליד תו יוניקוד בלתי-נראה אחד לתיבת הקלט, יחד עם מקשי ניווט שמחזירים את הסמן למקומו (Ctrl+Home ו-Ctrl+End בזריעת תחילת הודעה, Home ו-End בזריעת שורה חדשה; בזריעה לתוך טיוטה קיימת הסמן נע לסוף - מתועד במגבלות). זה כל מה שהוא מקליד אי-פעם, והוא מכוון רק לחלון הראשי של קלוד - דיאלוגים מקומיים, כמו בוחר הקבצים, מסוננים לפי window class. בנוסף הוא בודק כל 300 מילישניות אילו חלונות של `Claude.exe` קיימים ומה כותרת החלון הפעיל, כדי לזהות מעבר לשיחה אחרת; הכותרת נשמרת בזיכרון בלבד לצורך השוואה, אינה נכתבת לדיסק ואינה נשלחת לשום מקום. כל מסלולי הזריעה האוטומטיים בודקים מחדש ברגע הביצוע שחלון קלוד הראשי פעיל ושפריסת המקלדת עברית.

**ה-keyboard hook, בלי יפיוף:** כדי לזהות Enter בתוך קלוד, הסקריפט משתמש ב-hook מקלדת סטנדרטי של ווינדוס - אותו מנגנון שמשמש כל כלי קיצורי-דרך, קורא-מסך ומרחיב-טקסט. ליתר דיוק:

- ה-hook הוא מערכתי מעצם התכנון של ווינדוס; אי אפשר להתקין אותו "רק לאפליקציה אחת". קוד המקש של כל הקשה עובר דרכו.
- הפעולה היחידה על כל אירוע: השוואה מול רשימת הקיצורים הרשומים. כל השאר עובר הלאה ללא שינוי ואינו נשמר בשום מקום. השורות `KeyHistory 0` ו-`ListLines 0` מנטרלות גם את תצוגת המקשים האחרונים ואת יומן השורות המובנים של AutoHotkey, כך ששום הקשה ושום עקבת ריצה לא נשמרות אפילו בזיכרון.
- ה-hook אינו פועל ב-Secure Desktop, ולכן אינו רואה בקשות UAC ואינו רואה את מסך ההתחברות. הוא כן נמצא בנתיב של כל הקשה במושב האינטראקטיבי, כולל הקשות לחלונות שרצים כאדמין. זה נכון לכל hook מקלדת ברמה נמוכה, ולכן ההגנה כאן היא מה שנעשה עם האירוע ולא מגבלת הרשאות.
- שום דבר לא נכתב לדיסק ולא נשלח לשום מקום.

**בדיקה עצמית של הקוד (Ctrl+F בקובץ):**

- `Download`, `FileOpen`, `FileAppend`, `A_Clipboard` - לא מופיעים בקוד בכלל: אין רשת, אין קבצים, אין גישה ללוח. המילה clipboard מופיעה פעם אחת בלבד, בהערת הכותרת שמצהירה שאין גישה כזו.
- המילה Run על הטיותיה אינה מופיעה - אין הרצת תהליכים.
- `DllCall` מופיע פעמיים בדיוק - `GetWindowThreadProcessId` ו-`GetKeyboardLayout`, שתיהן לזיהוי פריסת המקלדת. כל `DllCall` אחר בקובץ הוא דגל אדום.
- אין בקובץ אף תו בלתי-נראה - התו נבנה בקוד כ-`Chr(0x202B)` והמקור כולו ASCII גלוי.

**אימות שרשרת האספקה:** התקינו את AutoHotkey רק מהמקור הרשמי, בגרסה הנעוצה שבפקודת ההתקנה. פקודת winget מאמתת את ה-hash אוטומטית מול ה-manifest של מיקרוסופט. מי שרוצה לאמת בעצמו יכול להוריד ידנית את קובץ ההתקנה מדף ה-release הרשמי ולהריץ עליו `Get-FileHash`:

<div dir="ltr">

```
AutoHotkey_2.0.26_setup.exe  2BF1B89B1047136490FC321D2FDC988B42DD86F693EEA7872746AC6ADF722BC3
AutoHotkey_2.0.26.zip        43522AA3122A57784AC5DB30ABF85C2244475C36ACD7796E2C993355F9E926AE
```

</div>

שני הערכים תקפים לגרסה 2.0.26 בלבד. ערך ה-setup ניתן להצלבה עצמאית מול ה-InstallerSha256 ב-manifest של מיקרוסופט במאגר winget-pkgs; את ערך ה-zip חישבנו בעצמנו מהקובץ הרשמי, מכיוון ש-AutoHotkey אינם מפרסמים רשימת hash רשמית. שימו לב: הבינארים של AutoHotkey הם קוד פתוח אבל **לא חתומים דיגיטלית**. האמון מגיע מבדיקת ה-hash, לא מתעודה. במחשבים עם Smart App Control הם רצים על סמך מוניטין הענן של מיקרוסופט (נבדק על מחשב עם SAC במצב אכיפה). מומלץ גם לחסום ל-`AutoHotkey64.exe` גישה לרשת בחומת האש - הכלי לא צריך רשת כלל ועובד מלא במצב לא-מקוון; ל-AutoHotkey אין טלמטריה ואין עדכונים אוטומטיים.

**אימות הסקריפט עצמו, ומה קורה כשהוא מתעדכן:** לסקריפט אין שום מנגנון עדכון עצמי - העותק שהורדתם וביקרתם הוא בדיוק מה שרץ אצלכם, עד שתחליפו אותו בעצמכם. מצד שני, הקובץ במאגר יכול להשתנות אחרי שביקרתם אותו - כמו בכל מאגר. לכן: הורידו מגרסה מתויגת או מ-commit מסוים ולא מ-main, שמרו את העותק שביקרתם, והתייחסו לכל החלפה של הקובץ כאל ביקורת חדשה - ב-264 שורות, diff בין שתי גרסאות הוא עניין של דקות.

**למנהלי IT:** הכלי רץ כולו במרחב המשתמש - התקנה per-user, בלי services, בלי drivers, בלי persistence מעבר לקיצור בתיקיית Startup שהמשתמש יוצר בעצמו. שטח ההתנהגות הרלוונטי ל-EDR: hook מקלדת (WH_KEYBOARD_LL), הזרקת SendInput של תו יוניקוד אחד בתוספת מקשי ניווט לחלון הקדמי כשהוא החלון הראשי של `Claude.exe`, שתי קריאות DllCall לזיהוי פריסת מקלדת, ופולינג של רשימת החלונות וכותרתם כל 300 מילישניות.

בסביבות WDAC או AppLocker: AutoHotkey אינו חתום ולכן publisher rule אינו אפשרי. הכלל צריך לחול על המפרש עצמו (`AutoHotkey64.exe`), לא על קובץ ההתקנה, ואת הערך יש להפיק מהבינארי המותקן אצלכם - AppLocker ו-WDAC משתמשים ב-Authenticode hash ולא בפלט של `Get-FileHash`:

<div dir="ltr">

```
Get-AppLockerFileInformation -Path '<path>\AutoHotkey64.exe'
```

</div>

אין להסתמך על path rule לנתיב ההתקנה הפר-משתמשי, שהמשתמש יכול לכתוב אליו.

**מצאתם בעיית אבטחה?** פתחו issue במאגר, או השתמשו ב-"Report a vulnerability" בלשונית Security של GitHub אם מעדיפים דיווח פרטי. אין כאן תוכנית באונטי - יש מתחזק אחד שמתייחס לדיווחים ברצינות.

## עמידות לעדכוני Claude Desktop

הסקריפט תלוי בשלושה דברים בלבד: שם התהליך (`Claude.exe`), ה-window class הסטנדרטי של חלון Chromium ראשי, וזה שתיבת הקלט מקבלת קלט מקלדת רגיל. הוא אינו קורא תוכן מהאפליקציה - לא DOM ולא קבצים; הדבר היחיד שהוא קורא הוא כותרת החלון. לכן עדכוני גרסה שוטפים אינם נוגעים בו.

**נבדק בפועל מול עדכון אמיתי (12.8.2026):** עדכון של האפליקציה מחנות מיקרוסופט (חבילת MSIX, גרסה 1.28929.0.0) התקין את עצמו באמצע יום עבודה והחליף את כל נתיב ההתקנה. שלוש התלויות החזיקו: שם התהליך נשאר `claude.exe` (ההתאמה היא לפי שם, לא לפי נתיב), ה-window class של החלון הראשי לא השתנה, והזרקת המקלדת המשיכה לעבוד - הסקריפט המשיך לתפקד בלי שינוי אחד. אגב אותה בדיקה נצפה שהחבילה מחזיקה גם חלון שני בלתי-נראה מאותו window class; אין לו השפעה, כי הסקריפט זורע רק לחלון הפעיל, וחלון בלתי-נראה לעולם אינו החלון הפעיל.

**אם אחרי עדכון נדמה שהתיקון נשבר - קודם כל בדקו שהסקריפט בכלל רץ:** אייקון AutoHotkey במגש המערכת (בווינדוס 11 ייתכן שמאחורי החץ), או `AutoHotkey64.exe` במנהל המשימות. עדכון סוגר ומפעיל מחדש את קלוד, אבל שום דבר לא מפעיל מחדש את הסקריפט אם נסגר בינתיים - קיצור הדרך ב-Startup רץ רק בכניסה למערכת. במקרה שתועד אצלנו, "התיקון הפסיק לעבוד אחרי העדכון" התברר ככזה בדיוק: הסקריפט לא רץ, והפעלה מחדש שלו (לחיצה כפולה על הקובץ) פתרה הכל מיד. מרגע שהוא רץ, הוא תופס גם חבילה שהוחלפה באמצע ריצה ומאפס את מצב הזריעה שלו תוך כ-3 שניות (עשרה טיקים של 300 מילישניות בלי אף חלון של קלוד).

- **תרחישי שבירה אפשריים:** שינוי שם התהליך (תיקון של שורה אחת) או סינון תווי bidi בתיבת הקלט (הסקריפט פשוט יפסיק להשפיע). בכל התרחישים המצב הוא "מפסיק לעזור", אף פעם לא "חוסם את קלוד".
- **תוכנית פרישה:** ברגע שאנת'רופיק יוסיפו תמיכת RTL מובנית לתיבת הקלט, פשוט מוחקים את הסקריפט. עד אז אפשר לעקוב אחרי [issue #38005](https://github.com/anthropics/claude-code/issues/38005) או כל issue עדכני אחר על תמיכת RTL. התו הזרוע אינו מתנגש עם RTL מובנה אם וכשיגיע.

## פרויקטים מקבילים

יש כמה כלים לתיקון RTL בקלוד, וכולם - למיטב בדיקתנו - שייכים למשפחה טכנית אחת: הם מחלצים את חבילת האפליקציה (asar), מזריקים לתוכה CSS ו-JavaScript, ואורזים אותה מחדש. זו גישה חזקה בהרבה מזו שכאן, והיא משלמת על כך במקום אחר.

- [liorshaya/claude-desktop-rtl](https://github.com/liorshaya/claude-desktop-rtl) - הפתרון המקיף ביותר: מטפל בתיבת הקלט, בתשובות, בטבלאות, ברשימות, בנוסחאות ובארטיפקטים, ומתקן גם יישור. תומך גם ב-macOS וגם ב-claude.ai. משנה את `claude.exe` ואת `app.asar`, מכבה את מנגנון אימות השלמות של Electron, ומחזיק watcher שמחיל את התיקון מחדש אחרי כל עדכון של האפליקציה.
- [shraga100/claude-desktop-rtl-patch](https://github.com/shraga100/claude-desktop-rtl-patch) - אותה משפחה: הזרקה ל-asar, החלפת ה-hash בתוך `claude.exe` והחלפת תעודה, עם התרוממות אוטומטית ל-UAC.
- קיימות גם גרסאות ל-macOS באותה שיטה, ותוספי דפדפן ל-claude.ai שמזריקים CSS ולכן פותרים גם את היישור. בסביבת הדפדפן קיים גם התוסף שלנו, [LegalMind RTL](https://chromewebstore.google.com/detail/legalmind-rtl/migkpjeadefcjmkgfambamobapngkaeo) - תצוגת RTL יציבה ב-Claude וב-ChatGPT בלחיצה אחת, כולל יישור (בדפדפן CSS אפשרי), עם זיכרון נפרד לכל אתר ובלי איסוף נתונים. בסביבה שבה אי אפשר להריץ AutoHotkey, תוסף דפדפן הוא החלופה הטובה.

**מה מייחד את הכלי הזה:** הוא היחיד שאינו נוגע באפליקציה בכלל. הוא אינו דורש הרשאות מנהל, אינו משנה שום קובץ, אינו מכבה שום מנגנון אבטחה, ולכן אין בו מה שיישבר בעדכון ואין צורך במנגנון שמחיל את עצמו מחדש. במחיר הזה הוא גם צנוע בהרבה: הוא מטפל בתיבת ההקלדה בלבד, אינו נוגע בתשובות, ואינו יכול לתקן יישור.

שני הבדלים נוספים ששווה להכיר לפני שבוחרים: הכלי הזה מוסיף תו בלתי-נראה לטקסט שנשלח, בעוד הפתרונות מבוססי ה-CSS משאירים את הטקסט זהה בית-בית; ומנגד, הם עובדים ברמת המסמך ולכן ניחוש הכיוון שלהם מתבסס על התו החזק הראשון, בעוד תו ההטמעה כאן הוא הוראה מפורשת ולכן עמיד גם במשפט עברי שנפתח במילה אנגלית.

## אפליקציות אחרות

הכלי מכוון ל-Claude Desktop בלבד, וזו החלטה מבוססת בדיקה ולא הנחה. בדקנו את אפליקציית ChatGPT לשולחן העבודה בווינדוס (חבילת OpenAI.Codex, שמכילה גם את ChatGPT וגם את Codex) עם משפטים מעורבים, בשורה אחת ובשתי שורות, ובלי שום תו זריעה - בשלושת המשטחים: Chat, Work וקודקס. בכולם העברית מוצגת נכון מלכתחילה, כולל יישור לימין. אין שם מה לתקן, והפעלת הכלי הזה עליהם רק תוסיף תו מיותר לטקסט.

## מי מאחורי הכלי

[Legal Mind](https://legalmind.co.il) - הדרכה והטמעת AI למשרדי עורכי דין. הכלי הזה נולד מהצורך היומיומי שלנו לכתוב עברית בקלוד. תוסף האח שלו לדפדפן, [LegalMind RTL](https://chromewebstore.google.com/detail/legalmind-rtl/migkpjeadefcjmkgfambamobapngkaeo), עושה את אותה עבודה - וגם יישור מלא - ב-claude.ai וב-ChatGPT בכרום.

## רישיון

MIT. ראו [LICENSE](LICENSE).

</div>

---

# Claude RTL Helper (English)

> An independent community project. Not affiliated with, sponsored by, or endorsed by Anthropic. Claude and Anthropic are trademarks of Anthropic PBC, used here only to identify the product this tool works with.
>
> Tested against Claude Desktop on Windows 11, August 2026.

![Before and after](before-after.png)

## What it does

The Claude Desktop message input on Windows is locked to left-to-right, which breaks Hebrew typing: punctuation lands on the wrong side and mixed Hebrew/Latin/number runs reorder. This single-file AutoHotkey v2 script (264 lines, about 165 of them code) fixes it at the keyboard level by seeding one invisible Unicode character (U+202B, RIGHT-TO-LEFT EMBEDDING) at the start of each message, and re-seeding after every Shift+Enter, since a line break ends a bidi paragraph.

It affects **only what you type**. Claude's own responses are rendered exactly as the app renders them, and the character order is fixed while the text stays **left aligned**.

**Timing:** seeding is asynchronous - it runs on short timers, not at the instant of the event. After launching the script or returning focus to the Claude window, the seed lands within about 0.6 seconds - the number that matters most day to day. After Enter it takes about a quarter second, after Shift+Enter it is effectively immediate (60ms), and after Ctrl+N about half a second, giving the new chat's input time to mount. Start-of-message seeding deliberately waits for a 250ms pause in typing so the caret jump never interleaves with keystrokes. Under truly continuous typing with no quarter-second pause it keeps waiting for the first one - so a message typed and sent in a single breath can go out unseeded; in practice such a pause almost always occurs, and Ctrl+Alt+J seeds immediately even mid-typing. A second focus return within 5 seconds of the previous one is rate-limited and seeds nothing. Ctrl+Alt+J always seeds immediately.

**Footprint:** nothing you can feel. The watcher wakes about three times a second for a few microsecond-scale window queries, and seeding types a single character only when something actually happened - a send, a line break, a focus return. No disk writes, no network, nothing accumulates in memory. Measured on a real machine: about 15MB of RAM and a sustained CPU load under one percent of a single core - less than an idle browser tab.

## Install

Open a normal, non-elevated terminal:

```
winget install AutoHotkey.AutoHotkey --version 2.0.26 --scope user
```

The AutoHotkey installer picks its own scope based on whether the terminal is elevated, so an elevated terminal produces a machine-wide install even with `--scope user`. Then download [`claude-rtl.ahk`](https://github.com/legalmindcode/legalmind-claude-desktop-rtl/raw/v1.1.0/claude-rtl.ahk) (direct link to the tagged version) and double-click it. For autostart, put a **shortcut** to it in `shell:startup`. Portable alternative: the official AutoHotkey zip, then drag the script onto `AutoHotkey64.exe` - note that this route registers no `.ahk` association, so an autostart shortcut must target `AutoHotkey64.exe` with the script path as its argument.

Uninstall: delete the shortcut from `shell:startup` and exit the script from its tray icon. Optionally `winget uninstall AutoHotkey.AutoHotkey`; the script itself leaves nothing behind, while the AutoHotkey installer creates a per-user program folder, a `.ahk` association and an uninstall entry, all removed by that command.

## Hotkeys

**One rule of thumb covers every situation: RTL did not kick in and the Hebrew came out broken? Press Ctrl+Alt+J once - fixed.** Everything else happens on its own.

- **Ctrl+Alt+J** - insert the RTL character at the caret. Works in the Claude main window only, but always works there, including when automatic seeding is off or the layout is English.
- **Ctrl+Alt+Shift+R** - toggle automatic seeding. Global; state shown in the tray.

## Security and privacy

Distributed as readable source only, never as a compiled binary. The script types exactly one invisible character plus navigation keys that normally restore the caret (Ctrl+Home / Ctrl+End; seeding into an existing draft moves the caret to the end - see Known limitations), aimed only at Claude's main window; native dialogs are filtered out by window class, and every scheduled seed re-checks its conditions at the moment it fires. It also polls every 300ms for `Claude.exe` windows and reads the active window title to detect a conversation switch; the title is held in memory for comparison only, never written to disk or transmitted.

Like every hotkey utility it installs a standard Windows low-level keyboard hook. Each key event is only compared against the registered hotkeys, and nothing is stored (`KeyHistory 0`, `ListLines 0`), logged, or transmitted. The hook does not run on the Secure Desktop, so it never sees UAC prompts or the logon screen; it is, like any low-level keyboard hook, in the path of every keystroke in the interactive session, including keystrokes to elevated windows - so the protection here is what the callback does with the event, not a permission boundary.

Self-audit with Ctrl+F: `Download`, `FileOpen`, `FileAppend`, `A_Clipboard` and the word Run in any form do not appear in the source; `DllCall` appears exactly twice (GetWindowThreadProcessId, GetKeyboardLayout - keyboard-layout detection); the source is pure visible ASCII, with the seed built as `Chr(0x202B)`.

AutoHotkey's official binaries are open source but unsigned. Verify the pinned release yourself:

```
AutoHotkey_2.0.26_setup.exe  2BF1B89B1047136490FC321D2FDC988B42DD86F693EEA7872746AC6ADF722BC3
AutoHotkey_2.0.26.zip        43522AA3122A57784AC5DB30ABF85C2244475C36ACD7796E2C993355F9E926AE
```

Recommended: firewall-block `AutoHotkey64.exe` outbound - the tool is fully offline.

**For IT administrators:** runs entirely in user space - per-user install, no services, no drivers, no persistence beyond a Startup shortcut the user creates. The EDR-relevant surface is a WH_KEYBOARD_LL hook, SendInput of one Unicode character plus two navigation chords into the foreground window when it belongs to `Claude.exe`, the two DllCalls above, and a 300ms window-list poll. Under WDAC or AppLocker, AutoHotkey is unsigned so no publisher rule is possible; allow the interpreter (`AutoHotkey64.exe`) by hash, generated from your own installed binary with `Get-AppLockerFileInformation`, since those engines use the Authenticode hash rather than `Get-FileHash` output. Do not rely on a path rule for the per-user install directory, which the user can write to.

## Known limitations

Character order is fixed but alignment stays left - in an input locked to `direction: ltr`, alignment is a CSS property that no control character can change, so this is an inherent ceiling of any keyboard-level approach rather than a bug. The invisible character travels with your message and survives copy-paste, so strip it before pasting message text into legal documents or code. Mouse actions inside the window - switching chats, starting a new chat, or clicking send - are invisible to the script, because the window title does not change between conversations and there is no other signal; returning focus to Claude from anywhere else does reseed, which covers most of those cases, and Ctrl+Alt+J covers the rest. That focus-return seed is placed at the caret without moving it, so an open draft is never disturbed, at the cost of one extra invisible character in that draft. Clearing a draft also clears the seed, and so does deleting a line back through its start - the character is invisible, so one Backspace swallows it with no cue until the line renders LTR again; Ctrl+Alt+J restores it. A seed landing in an existing draft moves the caret to the end. Picking a slash command or mention with Enter counts as a send, so one extra character may be seeded; it self-resets on the next real send. Pasted multi-line text is protected on its first line only, since the script never reads the clipboard. If focus is in another field of the Claude window at seed time, a single character may land there - clear it with Ctrl+A then Delete. If Claude runs elevated and the script does not, Windows UIPI silently blocks injection; run both unelevated.

## App updates

The script depends on three things only: the process name (`Claude.exe`), the standard Chromium main-window class, and the input box accepting ordinary keystrokes. Verified in practice against a real update - the Microsoft Store MSIX package 1.28929.0.0 (August 2026) replaced the app and its entire install path mid-session, and all three dependencies held: the script kept working unchanged, since it matches Claude by process name rather than path and resets its per-window state within about 3 seconds (ten 300ms watcher ticks with no Claude window) of the old process dying. That package also owns a second, invisible window of the same class - harmless, since the script only ever seeds the active window. If the fix seems broken right after an update, first check that the script itself is running (AutoHotkey tray icon, or `AutoHotkey64.exe` in Task Manager): an update restarts Claude, but nothing restarts the script mid-session - the Startup shortcut runs only at logon. The one documented "broke after an update" report turned out to be exactly that, and relaunching the script fixed it immediately.

## Related projects and scope

Every other Claude Desktop RTL tool we could find belongs to one technical family: extract the app's asar bundle, inject CSS and JavaScript, repack. [liorshaya/claude-desktop-rtl](https://github.com/liorshaya/claude-desktop-rtl) is the most complete of them - input box, responses, tables, lists, math and artifacts, alignment included, on macOS as well - and it modifies `claude.exe` and `app.asar`, turns off Electron's asar integrity validation, and keeps a watcher to re-apply itself after every app update. [shraga100/claude-desktop-rtl-patch](https://github.com/shraga100/claude-desktop-rtl-patch) is the same family, elevating through UAC. Browser extensions for claude.ai inject CSS and fix alignment too - including our own [LegalMind RTL](https://chromewebstore.google.com/detail/legalmind-rtl/migkpjeadefcjmkgfambamobapngkaeo), which covers Claude and ChatGPT in Chrome with per-site memory and no data collection.

What is distinctive here is that this tool never touches the application: no admin rights, no modified files, no security mechanism disabled, nothing to break on update and nothing to re-apply. The trade-offs are equally clear - it covers the input box only, never the responses, cannot fix alignment, and it does add an invisible character to the text you send, where the CSS-based tools leave your text byte-for-byte identical. In the other direction, because U+202B is an explicit instruction rather than a first-strong guess, it still resolves correctly for a Hebrew sentence that opens with an English word.

The ChatGPT desktop app on Windows (the OpenAI.Codex package, which contains both ChatGPT and Codex) was tested with the same mixed Hebrew sentences, single-line and multi-line, with no seed character, across its Chat, Work and Codex surfaces. All three render Hebrew correctly on their own, including right alignment, so this helper is neither needed nor useful there.

Built by [Legal Mind](https://legalmind.co.il), an Israeli AI-implementation and training practice for law firms. This tool grew out of our own daily need to type Hebrew in Claude.

MIT License.
