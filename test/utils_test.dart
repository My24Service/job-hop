import 'package:flutter_test/flutter_test.dart';
import 'package:jobhop/utils/generic.dart';

void main() {
  test('Test incorrect BSN', (){
    String incorrectBsn = '428639025';

    expect(isValidBsn(incorrectBsn), false);
  });

  test('Test correct BSN', (){
    String incorrectBsn = '428639021';

    expect(isValidBsn(incorrectBsn), true);
  });
}
