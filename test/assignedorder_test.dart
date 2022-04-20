import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

import 'package:jobhop/mobile/blocs/assignedorder_states.dart';
import 'package:jobhop/mobile/blocs/assignedorder_bloc.dart';
import 'package:jobhop/mobile/models/models.dart';
import 'package:jobhop/order/models/models.dart';
import 'package:jobhop/utils/state.dart';
import 'assignedorder_test.mocks.dart';

final GetIt getIt = GetIt.instance;

@GenerateMocks([http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  getIt.registerSingleton<AppModel>(AppModelImplementation(),
      signalsReady: true);

  test('Test fetch assigned orders', () async {
    final preferences = await SharedPreferences.getInstance();
    final client = MockClient();
    final AssignedOrderBloc assignedOrderBloc = AssignedOrderBloc(AssignedOrderInitialState());

    assignedOrderBloc.localMobileApi.httpClient = client;

    preferences.setInt('user_id', 1);
    preferences.setString('token', 'hsfudbsafdsuybafuysdbfua');
    preferences.setBool('fcm_allowed', false);

    // return assigned orders request with a 200
    final assignedOrdersData = '{"next":null,"previous":null,"count":1,"num_pages":1,"results":[{"id":229,"engineer":null,"student_user":215,"order":{"id":62,"customer_id":"1001","order_id":"10062","service_number":"","order_reference":"","order_type":"Rijdende Kerstmarkt","customer_remarks":"","description":null,"start_date":"15/06/2021","start_time":null,"end_date":"15/06/2021","end_time":null,"order_date":"15/06/2021","last_status":"toegewezen aan henk@gmail.com","order_name":"De Kerstmarktspecialist","order_address":"Metaalweg 4","order_postal":"3751 LS","order_city":"Bunschoten","order_country_code":"NL","order_tel":"033-2474013","order_mobile":"","order_email":"info@kerstmarktspecialist.nl","order_contact":"H. Buitenhuis","last_status_full":"15/06/2021 09:45 toegewezen aan henk@gmail.com","required_users":5,"created":"2021/06/13 10:12","total_price_purchase":"0.00","total_price_selling":"0.00", "documents": []},"started":"-","ended":"-"}]}';
    when(client.get(
      Uri.parse('https://jobhop.my24service-dev.com/api/mobile/assignedorder/list_app/'),
      headers: anyNamed('headers'))
    ).thenAnswer((_) async => http.Response(assignedOrdersData, 200));

    assignedOrderBloc.stream.listen(
      expectAsync1((event) {
        expect(event, isA<AssignedOrdersLoadedState>());
        expect(event.props[0], isA<AssignedOrders>());
      })
    );

    expectLater(assignedOrderBloc.stream, emits(isA<AssignedOrdersLoadedState>()));

    assignedOrderBloc.add(
      AssignedOrderEvent(
        status: AssignedOrderEventStatus.FETCH_ALL
      )
    );
  });

  test('Test fetch assigned order', () async {
    final client = MockClient();
    final AssignedOrderBloc assignedOrderBloc = AssignedOrderBloc(AssignedOrderInitialState());
    assignedOrderBloc.localMobileApi.httpClient = client;

    // return assigned order request with a 200
    final assignedOrderData = '{"id": 7183,"engineer": 22,"student_user": null,"order": {"id": 6484,"customer_id": "1018","order_id": "19416","total_price_purchase": "0.00","total_price_selling": "0.00", "documents": []},"started": "-","ended": "-"}';
    when(client.get(
        Uri.parse('https://jobhop.my24service-dev.com/api/mobile/assignedorder/1/detail_device/'),
        headers: anyNamed('headers'))
    ).thenAnswer((_) async => http.Response(assignedOrderData, 200));

    assignedOrderBloc.stream.listen(
        expectAsync1((event) {
          expect(event, isA<AssignedOrderLoadedState>());
          expect(event.props[0], isA<AssignedOrder>());
        })
    );

    expectLater(assignedOrderBloc.stream, emits(isA<AssignedOrderLoadedState>()));

    assignedOrderBloc.add(
        AssignedOrderEvent(
            status: AssignedOrderEventStatus.FETCH_DETAIL,
            value: 1
        )
    );
  });

  test('Test report start order', () async {
    final client = MockClient();
    final AssignedOrderBloc assignedOrderBloc = AssignedOrderBloc(AssignedOrderInitialState());
    assignedOrderBloc.localMobileApi.httpClient = client;

    // return start order request with a 200
    when(client.post(
        Uri.parse('https://jobhop.my24service-dev.com/api/mobile/assignedorder/1/report_statuscode/'),
        headers: anyNamed('headers'), body: anyNamed('body'))
    ).thenAnswer((_) async => http.Response('', 200));

    assignedOrderBloc.stream.listen(
        expectAsync1((event) {
          expect(event, isA<AssignedOrderReportStartCodeState>());
          expect(event.props[0], true);
        })
    );

    expectLater(assignedOrderBloc.stream, emits(isA<AssignedOrderReportStartCodeState>()));

    StartCode startCode = StartCode(
      statuscode: 'test'
    );

    assignedOrderBloc.add(
        AssignedOrderEvent(
            status: AssignedOrderEventStatus.REPORT_STARTCODE,
            value: 1,
            code: startCode
        )
    );
  });

  test('Test report end order', () async {
    final client = MockClient();
    final AssignedOrderBloc assignedOrderBloc = AssignedOrderBloc(AssignedOrderInitialState());
    assignedOrderBloc.localMobileApi.httpClient = client;

    // return end order request with a 200
    when(client.post(
        Uri.parse('https://jobhop.my24service-dev.com/api/mobile/assignedorder/1/report_statuscode/'),
        headers: anyNamed('headers'), body: anyNamed('body'))
    ).thenAnswer((_) async => http.Response('', 200));

    assignedOrderBloc.stream.listen(
        expectAsync1((event) {
          expect(event, isA<AssignedOrderReportEndCodeState>());
          expect(event.props[0], true);
        })
    );

    expectLater(assignedOrderBloc.stream, emits(isA<AssignedOrderReportEndCodeState>()));

    EndCode endCode = EndCode(
        statuscode: 'test'
    );

    assignedOrderBloc.add(
        AssignedOrderEvent(
            status: AssignedOrderEventStatus.REPORT_ENDCODE,
            value: 1,
            code: endCode
        )
    );
  });
}
