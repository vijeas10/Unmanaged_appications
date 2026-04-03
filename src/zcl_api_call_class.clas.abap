CLASS zcl_api_call_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_weather_units,
             temperature TYPE string,
             windspeed   TYPE string,
           END OF ty_weather_units.

    TYPES: BEGIN OF ty_current_weather,
             time        TYPE string,
             temperature TYPE decfloat16,
             windspeed   TYPE decfloat16,
           END OF ty_current_weather.

    TYPES: BEGIN OF ty_weather,
             latitude              TYPE decfloat16,
             longitude             TYPE decfloat16,
             current_weather       TYPE ty_current_weather,
             current_weather_units TYPE ty_weather_units,
           END OF ty_weather.
    METHODS:fetch_weather.
    CLASS-DATA: we_weather TYPE ty_weather.


    INTERFACES if_oo_adt_classrun .
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_API_CALL_CLASS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA: lo_client      TYPE REF TO if_web_http_client,
          lo_response    TYPE REF TO if_web_http_response,
          lo_destination TYPE REF TO if_http_destination,
          lv_result      TYPE string.

    DATA(lv_url) = 'https://api.open-meteo.com/v1/forecast?' && 'latitude=28.61&longitude=77.20&current_weather=true'.

    TRY.
        cl_http_destination_provider=>create_by_url(
          EXPORTING
            i_url              = lv_url
          RECEIVING
            r_http_destination = lo_destination
        ).

* Create HTTP client
        cl_web_http_client_manager=>create_by_http_destination(
          EXPORTING
            i_destination = lo_destination
          RECEIVING
            r_client      = lo_client
        ).


* Send GET request
        lo_response = lo_client->execute(
          if_web_http_client=>get ).

* Get response text
        lv_result = lo_response->get_text( ).
* Parse JSON response
        /ui2/cl_json=>deserialize(
          EXPORTING
            json = lv_result
          CHANGING
            data = we_weather ).
*Display output
        out->write( we_weather ).

      CATCH cx_web_http_client_error cx_http_dest_provider_error.

    ENDTRY.

  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    IF io_request->is_data_requested( ).
      DATA(wl_entity) = io_request->get_entity_id( ). "gets the entity name which is called in our case ZI_CUSTOM_ENTITY_API
      CASE wl_entity.
        WHEN 'ZI_CUSTOM_ENTITY_API'.
          TRY.
              DATA(lv_skip) = io_request->get_paging( )->get_offset( ). "gets the skip part from URL which means number of data to be skipped and default is 0 but later on it gets add by 20... till last data not get fetched
*              DATA(lv_top) = io_request->get_paging( )->get_page_size( ). "gets the top part from URL which means number of data required and default is 20
*              DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ). "gets the input value which is either pass in our filters or when click on single data line item

            CATCH cx_rap_query_filter_no_range.
              "handle exception
          ENDTRY.

          DATA:wtl_return TYPE STANDARD TABLE OF zi_custom_entity_api.
          me->fetch_weather( ).
          wtl_return = VALUE #(
              (
               temperature   = we_weather-current_weather-temperature
               temperature_u = we_weather-current_weather_units-temperature
               windspeed    = we_weather-current_weather-windspeed
               windspeed_u  = we_weather-current_weather_units-windspeed
               time         = we_weather-current_weather-time
               latitude     =  we_weather-latitude
               longitude    = we_weather-longitude

               )
                             ).

          TRY.
              io_response->set_total_number_of_records( lines( wtl_return )  ).
            CATCH cx_rap_query_response_set_twic.
          ENDTRY.

          io_response->set_data( wtl_return ).

      ENDCASE.
    ENDIF.


  ENDMETHOD.


  METHOD fetch_weather.

    DATA: lo_client      TYPE REF TO if_web_http_client,
          lo_response    TYPE REF TO if_web_http_response,
          lo_destination TYPE REF TO if_http_destination,
          lv_result      TYPE string.

    DATA(lv_url) = 'https://api.open-meteo.com/v1/forecast?' && 'latitude=28.61&longitude=77.20&current_weather=true'.

    TRY.
        cl_http_destination_provider=>create_by_url(
          EXPORTING
            i_url              = lv_url
          RECEIVING
            r_http_destination = lo_destination
        ).

* Create HTTP client
        cl_web_http_client_manager=>create_by_http_destination(
          EXPORTING
            i_destination = lo_destination
          RECEIVING
            r_client      = lo_client
        ).


* Send GET request
        lo_response = lo_client->execute(
          if_web_http_client=>get ).

* Get response text
        lv_result = lo_response->get_text( ).
* Parse JSON response
        /ui2/cl_json=>deserialize(
          EXPORTING
            json = lv_result
          CHANGING
            data = we_weather ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
