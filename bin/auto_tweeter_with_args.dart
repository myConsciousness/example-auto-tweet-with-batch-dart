import 'package:batch/batch.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart';

/// Run this application with command:
/// `dart run bin/auto_tweeter_with_args.dart -b YOUR_BEARER_TOKEN -k YOUR_CONSUMER_KEY -c YOUR_CONSUMER_SECRET -t YOUR_TOKEN -s YOUR_SECRET`
void main(List<String> args) => BatchApplication(
      args: args,
      argsConfigBuilder: (parser) => parser
        ..addOption('apiBearerToken', abbr: 'b')
        ..addOption('apiConsumerKey', abbr: 'k')
        ..addOption('apiConsumerSecret', abbr: 'c')
        ..addOption('apiToken', abbr: 't')
        ..addOption('apiSecret', abbr: 's'),
      onLoadArgs: (args) {
        final twitter = TwitterApi(
          bearerToken: args['apiBearerToken'],

          // Or you can use OAuth 1.0a tokens.
          oauthTokens: OAuthTokens(
            consumerKey: args['apiConsumerKey'],
            consumerSecret: args['apiConsumerSecret'],
            accessToken: args['apiToken'],
            accessTokenSecret: args['apiSecret'],
          ),
        );

        // Add instance of TwitterApi to shared parameters.
        // This instance can be used from anywhere in this batch application as a singleton instance.
        return {'twitterApi': twitter};
      },
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
    // Get TwitterApi instance from shared parameters.
    final TwitterApi twitter = context.sharedParameters['twitterApi'];

    try {
      // Auto tweet
      await twitter.tweetsService.createTweet(text: 'Hello, world!');
    } catch (e, s) {
      log.error('Failed to tweet', e, s);
    }
  }
}
