import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

import 'package:jobhop/mobile/models/models.dart';
import 'package:jobhop/mobile/blocs/availability_bloc.dart';
import 'package:jobhop/mobile/blocs/availability_states.dart';
import 'package:jobhop/utils/state.dart';
import 'availability_test.mocks.dart';

final GetIt getIt = GetIt.instance;

@GenerateMocks([http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  getIt.registerSingleton<AppModel>(AppModelImplementation(),
      signalsReady: true);

  test('Test fetch availability', () async {
    final client = MockClient();
    final TripUserAvailabilityBloc availabilityBloc = TripUserAvailabilityBloc(
        TripUserAvailabilityInitialState());
    availabilityBloc.localMobileApi.httpClient = client;

    // return result with a 200
    final String availabilitiesResponse = '{"next": null,"previous": null,"count": 1,"num_pages": 1,"results": [{"id": 8,"user": {"id": 231,"email": "henk@gmail.com","username": "henk@gmail.com","last_login": "2021-06-14T13:23:54.701566","date_joined": "2021-06-12T08:28:19.161935","first_name": "Richard","last_name": "Jansen","full_name": "Henk Jansen","student_user": {"address": "sdf, sdf, sdf","rating_avg": null,"info": "sdf","picture": "","wp_image": null,"iban": "NL71ABNA1245679854","external_id": null}},"trip": 9,"is_accepted": false,"description": "tets","trip_date": "21/06/2021 12:15 - 23/06/2021 13:00","created": "14/06/2021 11:32","modified": "14/06/2021 11:32"}]}';
    when(client.get(
        Uri.parse('https://jobhop.my24service-dev.com/mobile/user-trip-availability/'),
        headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(availabilitiesResponse, 200));

    availabilityBloc.stream.listen(
        expectAsync1((event) {
          expect(event, isA<TripUserAvailabilitiesLoadedState>());
          expect(event.props[0], isA<TripUserAvailabilities>());
        })
    );

    expectLater(availabilityBloc.stream, emits(isA<TripUserAvailabilitiesLoadedState>()));

    availabilityBloc.add(
        TripUserAvailabilityEvent(
            status: TripUserAvailabilityEventStatus.FETCH_ALL,
        )
    );
  });

  test('Test delete availability', () async {
    final client = MockClient();
    final TripUserAvailabilityBloc availabilityBloc = TripUserAvailabilityBloc(
        TripUserAvailabilityInitialState());
    availabilityBloc.localMobileApi.httpClient = client;

    // return result with a 204
    when(client.delete(
        Uri.parse('https://jobhop.my24service-dev.com/mobile/user-trip-availability/1/'),
        headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('', 204));

    availabilityBloc.stream.listen(
        expectAsync1((event) {
          expect(event, isA<TripUserAvailabilityDeletedState>());
          expect(event.props[0], true);
        })
    );

    expectLater(availabilityBloc.stream, emits(isA<TripUserAvailabilityDeletedState>()));

    availabilityBloc.add(
        TripUserAvailabilityEvent(
          status: TripUserAvailabilityEventStatus.DELETE,
          value: 1
        )
    );
  });
}
