@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interafce view for Bank details'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zi_bank_vj
  as select from I_Bank_2
{
  key BankCountry,
  key BankInternalID,
      BankName,
      SWIFTCode,
      BankNetworkGrouping,
      IsMarkedForDeletion,
      Bank,
      BankBranch,
      BankCategory
}
