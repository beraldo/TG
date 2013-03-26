//
//  Common.h
//  Minhas Apostas
//
//  Created by Roberto Beraldo Chaiben on 21/12/12.
//  Copyright (c) 2012 Master Coding. All rights reserved.
//

#ifndef UFPR_RA_Common_h
#define UFPR_RA_Common_h



/* =================
 * Constantes
 * =============== */

// ID do app
#define APP_ID 1

// nome do campo do NSUserDefaults que diz quantas vezes o app foi rodado
#define TOTAL_OF_APP_LAUNCHES_KEY @"totalOfAppLauches"

// nome do campo do NSUserDefaults que diz se o usuário já avaliou o app
#define DID_USER_RATE_APP_KEY @"didUserRateApp"

// nome do campo do NSUserDefaults que diz se deve mostrar o diálogo para avaliar o app
#define SHOULD_SHOW_RATE_APP_DIALOG_KEY @"shouldShowRateAppDialog"



/* ============================
 * Dados do desenvolvedor
 * ========================== */

#define DEVELOPER_SITE  @"http://rberaldo.com.br"
#define DEVELOPER_EMAIL @"rbchaiben@gmail.com"
#define DEVELOPER_APPS @"itms-apps://itunes.com/apps/RobertoBeraldoChaiben/id498512305"




/* ================
 * Macros
 * ============== */

// macro que verifica se é iPhone 5
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )



#endif
