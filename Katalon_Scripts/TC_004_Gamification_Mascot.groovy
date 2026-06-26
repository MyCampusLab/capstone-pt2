import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.mobile.keyword.MobileBuiltInKeywords as Mobile

'Membuka Tab Gamifikasi'
Mobile.tap(findTestObject('Object Repository/Dashboard/Tab_Gamification'), 3)

'Mengecek ketersediaan Animasi Lottie Mascot Vizo'
Mobile.verifyElementVisible(findTestObject('Object Repository/Gamification/Lottie_Mascot_Idle'), 5)

'Simulasi pembelian Hero (Sticker) dengan XP'
Mobile.tap(findTestObject('Object Repository/Gamification/Btn_Buy_Hero'), 3)

'Memastikan saldo XP berkurang'
Mobile.verifyElementText(findTestObject('Object Repository/Gamification/Text_XP_Balance'), '450 XP')

'Mengecek perubahan State Mascot menjadi Happy'
Mobile.verifyElementVisible(findTestObject('Object Repository/Gamification/Lottie_Mascot_Happy'), 5)
