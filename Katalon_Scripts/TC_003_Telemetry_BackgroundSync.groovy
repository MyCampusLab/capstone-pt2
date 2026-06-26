import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.mobile.keyword.MobileBuiltInKeywords as Mobile

'Simulasi menutup layar HP (Background Mode)'
Mobile.pressHome()
Mobile.delay(10) // Tunggu 10 detik di background

'Kembali ke aplikasi'
Mobile.startExistingApplication('com.hn.visionsafe')

'Memeriksa apakah Kotlin Foreground Service masih berjalan'
Mobile.verifyElementVisible(findTestObject('Object Repository/Dashboard/Status_Camera_Active'), 5)

'Menarik data statistik terbaru dari Supabase'
Mobile.tap(findTestObject('Object Repository/Dashboard/Btn_Sync_Data'), 3)
Mobile.waitForElementVisible(findTestObject('Object Repository/Dashboard/Chart_Weekly'), 10)

'Memverifikasi bahwa data log pelanggaran terupdate'
def logCount = Mobile.getText(findTestObject('Object Repository/Dashboard/Text_Total_Violations'), 3)
Mobile.verifyNotEqual(logCount, '0', FailureHandling.STOP_ON_FAILURE)
