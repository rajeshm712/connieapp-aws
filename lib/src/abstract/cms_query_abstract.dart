// Created by Sanjeev Sangral on 15/2/21.
abstract class CMSQueryAbstract{
  Future<String> cmsQuery(bool ttsNative,String startOrStop,String accessToken,String callTo);
}