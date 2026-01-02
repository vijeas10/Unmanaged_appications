CLASS lhc_zi_bank_vj DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_bank_vj RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zi_bank_vj.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_bank_vj.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_bank_vj.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_bank_vj RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_bank_vj.

ENDCLASS.

CLASS lhc_zi_bank_vj IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA :wel_create TYPE STRUCTURE FOR CREATE i_banktp.

    wel_create = VALUE #( %cid =  entities[ 1 ]-%cid
                          bankcountry  = entities[ 1 ]-BankCountry
                          bankinternalid = entities[ 1 ]-BankInternalID
                          longbankname = entities[ 1 ]-BankName
                          longbankbranch  = entities[ 1 ]-BankBranch
                          banknumber = entities[ 1 ]-Bank
                          bankcategory = entities[ 1 ]-BankCategory
                          banknetworkgrouping = entities[ 1 ]-BankNetworkGrouping


     ).

    MODIFY ENTITIES OF I_BankTP
    PRIVILEGED
    ENTITY Bank
    CREATE FIELDS (     bankcountry
                        bankinternalid
                        longbankname
                        longbankbranch
                        banknumber
                        bankcategory
                        banknetworkgrouping )
  WITH VALUE #( (  %cid = 'cid1'
                   bankcountry         =  wel_create-bankcountry
                    bankinternalid      =  wel_create-bankinternalid
                    longbankname        =  wel_create-longbankname
                    longbankbranch      =  wel_create-longbankbranch
                    banknumber          =  wel_create-banknumber
                    bankcategory        =  wel_create-bankcategory
                    banknetworkgrouping =  wel_create-banknetworkgrouping
               )  )
MAPPED DATA(wtl_mapped)
FAILED DATA(wtl_failed)
REPORTED DATA(wtl_reported).


*    mapped-zi_bank_vj = CORRESPONDING #( wtl_mapped-bank ).

  ENDMETHOD.

  METHOD update.
*   Select DB data first
    DATA(wel_updated) = VALUE #( entities[ 1 ]  OPTIONAL ).
    SELECT  SINGLE * FROM zi_bank_vj
         WHERE BankCountry = @wel_updated-BankCountry
         AND  BankInternalID = @wel_updated-BankInternalID
         INTO  @DATA(wel_existing).
    IF sy-subrc IS INITIAL.
      MODIFY ENTITIES OF I_BankTP
      PRIVILEGED ENTITY Bank
      UPDATE FIELDS ( LongBankName
                      LongBankBranch
                      SWIFTCode
                     )
      WITH VALUE #(
                    (
                    %key-BankCountry = wel_updated-BankCountry
                    %key-BankInternalID = wel_updated-BankInternalID
                    LongBankName = COND #( WHEN wel_updated-%control-BankName = '01' THEN wel_updated-BankName
                                           ELSE wel_existing-BankName
                                           )
                    LongBankBranch = COND #( WHEN wel_updated-%control-BankBranch = '01' THEN wel_updated-BankBranch
                                           ELSE wel_existing-BankBranch
                                            )
                    SWIFTCode      = COND #( WHEN wel_updated-%control-SWIFTCode = '01' THEN wel_updated-SWIFTCode
                                           ELSE wel_existing-SWIFTCode
                                           )
                     )
                  )

                  MAPPED DATA(wtl_mapped)
                  FAILED DATA(wtl_failed).

    ENDIF.

  ENDMETHOD.

  METHOD delete.
    APPEND VALUE #( %tky = keys[ 1 ]-%tky ) TO failed-zi_bank_vj.
    APPEND VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                  text = 'Delete functionality is not enabled ' )
                   ) TO reported-zi_bank_vj.



  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_BANK_VJ DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_BANK_VJ IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
