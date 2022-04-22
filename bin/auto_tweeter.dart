import 'package:batch/batch.dart';
import 'package:dart_twitter_api/twitter_api.dart';

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
    // You need to get your own API keys from https://apps.twitter.com/
    final twitter = TwitterApi(
      client: TwitterClient(
        consumerKey: 'Your consumer key',
        consumerSecret: 'Your consumer secret',
        token: 'Your token',
        secret: 'Your secret',
      ),
    );

    try {
      // Auto tweet
      await twitter.tweetService.update(status: 'Hello, world!');
    } catch (e, s) {
      log.error('Failed to tweet', e, s);
    }
  }
}
