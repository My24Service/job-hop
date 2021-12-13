import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

import 'package:jobhop/mobile/models/models.dart';
import 'package:jobhop/mobile/blocs/trip_bloc.dart';
import 'package:jobhop/mobile/blocs/trip_states.dart';
import 'package:jobhop/utils/state.dart';
import 'trips_test.mocks.dart';

final GetIt getIt = GetIt.instance;

@GenerateMocks([http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  getIt.registerSingleton<AppModel>(AppModelImplementation(),
      signalsReady: true);

  test('Test fetch trips', () async {
    final client = MockClient();
    final TripBloc tripBloc = TripBloc(
        TripInitialState());
    tripBloc.localMobileApi.httpClient = client;

    // return result with a 200
    final String tripsResponse = '{"next":null,"previous":null,"count":1,"num_pages":1,"results":[{"id":9,"description":"tets","required_users":5,"trip_orders":[{"id":18,"order":62,"name":"De Kerstmarktspecialist","address":"Metaalweg 4","postal":"3751 LS","city":"Bunschoten","country_code":"NL","date":"14/06/2021","start_date": "2021-12-06", "start_time": "14:00:00", "end_date": "2021-12-06", "end_time": "17:00:00","modified":"13/06/2021 10:32","created":"13/06/2021 10:32"}],"start_date":"2021-06-21","start_time":"12:15:00","end_date":"2021-06-23","end_time":"13:00:00","modified":"13/06/2021 10:32","created":"13/06/2021 10:32","trip_date":"21/06/2021 12:15 - 23/06/2021 13:00","user_trip_is_available":false,"required_assigned":"0/0 (0.00%)","assigned_user_count":0,"num_orders":1,"users_trip_set_as_available":1,"number_still_available":4}]}';
    when(client.get(
        Uri.parse('https://jobhop.my24service-dev.com/mobile/trip/?page_size=500'),
        headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(tripsResponse, 200));

    tripBloc.stream.listen(
        expectAsync1((event) {
          expect(event, isA<TripsLoadedState>());
          expect(event.props[0], isA<Trips>());
        })
    );

    expectLater(tripBloc.stream, emits(isA<TripsLoadedState>()));

    tripBloc.add(
        TripEvent(
          status: TripEventStatus.FETCH_ALL,
        )
    );
  });

  test('Test set available', () async {
    final client = MockClient();
    final TripBloc tripBloc = TripBloc(
        TripInitialState());
    tripBloc.localMobileApi.httpClient = client;

    // return trip fetch with a 200
    // this is done after set avaiable is successful
    final String tripResponse = '{"id":9,"description":"tets","required_users":5,"trip_orders":[{"id":18,"order":62,"name":"De Kerstmarktspecialist","address":"Metaalweg 4","postal":"3751 LS","city":"Bunschoten","country_code":"NL","date":"14/06/2021","start_date": "2021-12-06", "start_time": "14:00:00", "end_date": "2021-12-06", "end_time": "17:00:00","modified":"13/06/2021 10:32","created":"13/06/2021 10:32"}],"start_date":"2021-06-21","start_time":"12:15:00","end_date":"2021-06-23","end_time":"13:00:00","modified":"13/06/2021 10:32","created":"13/06/2021 10:32","trip_date":"21/06/2021 12:15 - 23/06/2021 13:00","user_trip_is_available":false,"required_assigned":"0/0 (0.00%)","assigned_user_count":0,"num_orders":1,"users_trip_set_as_available":1,"number_still_available":4}';
    when(client.get(
        Uri.parse('https://jobhop.my24service-dev.com/mobile/trip/1/'),
        headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(tripResponse, 200));

    // return result with a 201
    when(client.post(
        Uri.parse('https://jobhop.my24service-dev.com/mobile/user-trip-availability/'),
        body: anyNamed('body'),
        headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('', 201));

    tripBloc.stream.listen(
        expectAsync1((event) {
          expect(event, isA<TripSetAvailableState>());
          expect(event.props[0], true);
        })
    );

    expectLater(tripBloc.stream, emits(isA<TripSetAvailableState>()));

    tripBloc.add(
        TripEvent(
          status: TripEventStatus.SET_AVAILABLE,
          value: 1
        )
    );
  });
}
