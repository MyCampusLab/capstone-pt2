import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.mobile.keyword.MobileBuiltInKeywords as Mobile

'Membuka pengaturan'
Mobile.tap(findTestObject('Object Repository/Btn_Settings'), 3)

'Mencoba mematikan Mode Disiplin'
Mobile.tap(findTestObject('Object Repository/Toggle_Discipline_Mode'), 3)

'Memastikan Dialog Matematika muncul (Security Gate)'
Mobile.verifyElementVisible(findTestObject('Object Repository/Dialog_Math_Challenge'), 5)

'Menyimulasikan input jawaban salah (Negative Test)'
Mobile.setText(findTestObject('Object Repository/Input_Math_Answer'), '9999')
Mobile.tap(findTestObject('Object Repository/Btn_Submit_Answer'), 3)

'Mengecek notifikasi kegagalan'
Mobile.verifyElementVisible(findTestObject('Object Repository/Toast_Math_Failed'), 5)

'Mencoba membobol dialog dengan klik area luar (Barrier Dismissible Bypass)'
Mobile.tapAtPosition(100, 100)

'Memastikan dialog TIDAK HILANG (Aman dari Bypass Anak)'
Mobile.verifyElementVisible(findTestObject('Object Repository/Dialog_Math_Challenge'), 3)
