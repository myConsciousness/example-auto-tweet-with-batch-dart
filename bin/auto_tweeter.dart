import 'package:batch/batch.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart';

void main(List<String> args) => BatchApplication(
      jobs: [AutoTweetJob()],
    )..run();

class AutoTweetJob implements ScheduledJobBuilder {
  @override
  ScheduledJob build() => ScheduledJob(
        name: 'Auto Tweet Job',
        schedule: CronParser('* */1 * * *'), // Will be executed hourly
        steps: [
          Step(
            name: 'Auto Tweet Step',
            task: AutoTweetJobTask(),
          )
        ],
      );
}

class AutoTweetJobTask extends Task<AutoTweetJobTask> {
  @override
  Future<void> execute(ExecutionContext context) async {
    // You need to get your own tokens from https://apps.twitter.com/
    final twitter = TwitterApi(
      bearerToken: 'YOUR_BEARER_TOKEN_HERE',

      // Or you can use OAuth 1.0a tokens.
      oauthTokens: OAuthTokens(
        consumerKey: 'YOUR_API_KEY_HERE',
        consumerSecret: 'YOUR_API_SECRET_HERE',
        accessToken: 'YOUR_ACCESS_TOKEN_HERE',
        accessTokenSecret: 'YOUR_ACCESS_TOKEN_SECRET_HERE',
      ),
    );

    try {
      // Auto tweet
      await twitter.tweetsService.createTweet(text: 'Hello, world!');
    } catch (e, s) {
      log.error('Failed to tweet', e, s);
    }
  }
}
