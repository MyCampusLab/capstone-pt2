import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.mobile.keyword.MobileBuiltInKeywords as Mobile
import com.kms.katalon.core.testdata.TestDataFactory

'Load Data-Driven Testing (CSV) for Multiple Users'
def loginData = TestDataFactory.findTestData('Data Files/Login_Credentials')

for (int i = 1; i <= loginData.getRowNumbers(); i++) {
    def email = loginData.getValue('Email', i)
    def password = loginData.getValue('Password', i)
    
    Mobile.setText(findTestObject('Object Repository/Auth/Input_Email'), email, 5)
    Mobile.setText(findTestObject('Object Repository/Auth/Input_Password'), password, 5)
    Mobile.tap(findTestObject('Object Repository/Auth/Btn_Login'), 3)
    
    'Validasi respon Supabase'
    if (email.contains('invalid')) {
        Mobile.verifyElementVisible(findTestObject('Object Repository/Auth/Toast_Error'), 5)
    } else {
        Mobile.verifyElementVisible(findTestObject('Object Repository/Dashboard/Header_Profile'), 10)
        Mobile.tap(findTestObject('Object Repository/Dashboard/Btn_Logout'), 3)
    }
}
