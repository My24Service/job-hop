import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

import 'package:jobhop/mobile/blocs/activity_bloc.dart';
import 'package:jobhop/mobile/blocs/activity_states.dart';
import 'package:jobhop/mobile/models/models.dart';
import 'package:jobhop/utils/state.dart';
import 'activity_test.mocks.dart';

final GetIt getIt = GetIt.instance;

@GenerateMocks([http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  getIt.registerSingleton<AppModel>(AppModelImplementation(),
      signalsReady: true);

  test('Test fetch all activities for an assigned order', () async {
    final client = MockClient();
    final activityBloc = ActivityBloc(ActivityInitialState());
    activityBloc.localMobileApi.httpClient = client;

    // return activity data with a 200
    final String activityData = '{"next": null, "previous": null, "count": 4, "num_pages": 1, "results": [{"id": 1, "assignedOrderId": 1, "work_start": "10:30:00", "work_end": "15:20:02"}]}';
    when(
        client.get(
            Uri.parse('https://jobhop.my24service-dev.com/api/mobile/assignedorderactivity/?assigned_order=1'),
            headers: anyNamed('headers')
        )
    ).thenAnswer((_) async => http.Response(activityData, 200));

    activityBloc.stream.listen(
      expectAsync1((event) {
        expect(event, isA<ActivitiesLoadedState>());
        expect(event.props[0], isA<AssignedOrderActivities>());
      })
    );

    expectLater(activityBloc.stream, emits(isA<ActivitiesLoadedState>()));

    activityBloc.add(
        ActivityEvent(
            status: ActivityEventStatus.FETCH_ALL,
            value: 1
        )
    );
  });

  test('Test activity insert', () async {
    final client = MockClient();
    final activityBloc = ActivityBloc(ActivityInitialState());
    activityBloc.localMobileApi.httpClient = client;

    AssignedOrderActivity activity = AssignedOrderActivity(
      assignedOrderId: 1,
      workStart: "10:20:00",
      workEnd: "16:40:00",
    );

    // return activity data with a 200
    final String activityData = '{"id": 1, "work_start": "10:20:00", "work_end": "13:20:20"}';
    when(
        client.post(Uri.parse('https://jobhop.my24service-dev.com/api/mobile/assignedorderactivity/'),
            headers: anyNamed('headers'),
            body: anyNamed('body')
        )
    ).thenAnswer((_) async => http.Response(activityData, 201));

    AssignedOrderActivity? newActivity = await activityBloc.localMobileApi.insertAssignedOrderActivity(activity, 1);
    expect(newActivity, isA<AssignedOrderActivity>());
  });

  test('Test activity delete', () async {
    final client = MockClient();
    final activityBloc = ActivityBloc(ActivityInitialState());
    activityBloc.localMobileApi.httpClient = client;
    // return activity delete result with a 204
    when(
        client.delete(Uri.parse('https://jobhop.my24service-dev.com/api/mobile/assignedorderactivity/1/'),
            headers: anyNamed('headers')
        )
    ).thenAnswer((_) async => http.Response('', 204));

    activityBloc.stream.listen(
      expectAsync1((event) {
        expect(event, isA<ActivityDeletedState>());
        expect(event.props[0], true);
      })
    );

    expectLater(activityBloc.stream, emits(isA<ActivityDeletedState>()));

    activityBloc.add(
        ActivityEvent(
            status: ActivityEventStatus.DELETE,
            value: 1
        )
    );
  });
}
