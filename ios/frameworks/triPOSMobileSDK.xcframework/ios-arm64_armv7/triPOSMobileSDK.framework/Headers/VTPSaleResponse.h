///
/// \file VTPSaleResponse.h
///

#ifndef VTPSaleResponse_h
#define VTPSaleResponse_h

#import "VTPFinancialResponseBase.h"
#import "VTPFinancialResponseAmounts.h"
#import "VTPFinancialResponseCashbackAmount.h"
#import "VTPFinancialResponseTipAmount.h"
#import "VTPFinancialResponseCard.h"
#import "VTPFinancialResponseCardVerification.h"
#import "VTPFinancialResponseEmv.h"
#import "VTPFinancialResponseHost.h"
#import "VTPStoreAndForwardResponse.h"
#import "VTPValutecRewardsResponse.h"

///
/// \class VTPSaleResponse
///
/// \brief The definition of the sale response
///
@interface VTPSaleResponse : NSObject <VTPFinancialResponseBase, VTPFinancialResponseAmounts, VTPFinancialResponseCashbackAmount, VTPFinancialResponseTipAmount,VTPFinancialResponseCard, VTPFinancialResponseCardVerification, VTPFinancialResponseEmv, VTPFinancialResponseHost, VTPStoreAndForwardResponse, VTPValutecRewardsResponse>

@end

#endif /* VTPSaleResponse_h */
