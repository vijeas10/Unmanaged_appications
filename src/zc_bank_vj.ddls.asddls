@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for bank details'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity zc_bank_vj
  provider contract transactional_query
  as projection on zi_bank_vj
{

      @Consumption.valueHelpDefinition: [{
          entity: {
              name: 'I_Bank_2',
              element: 'BankCountry'    }
              }]
  key BankCountry,
  key BankInternalID,
      @Consumption.valueHelpDefinition: [{
          entity: {
              name: 'I_Bank_2',
              element: 'BankName'    }
              }]
      BankName,
      SWIFTCode,
      BankNetworkGrouping,
      IsMarkedForDeletion,
      Bank,
      BankBranch,
      BankCategory
}
