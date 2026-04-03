@EndUserText.label: 'Custom Entity : API Call'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_API_CALL_CLASS'
//@ObjectModel.usageType: {
//    serviceQuality: #A,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}
@Metadata.allowExtensions: true
define root custom entity zi_custom_entity_api

{

  key temperature   : abap.dec( 5, 2 );
      temperature_u : abap.string( 256 );
      windspeed     : abap.dec( 5, 2 );
      windspeed_u   : abap.string( 256 );
      time          : abap.string( 256 );
      latitude      : abap.string( 256 );
      longitude     : abap.string( 256 );
      remark        : abap.string( 256 );

}
