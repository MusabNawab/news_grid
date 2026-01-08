# NewsGrid

A modern, responsive news application built with Flutter that fetches real-time news from [NewsAPI](https://newsapi.org/).

## Features

*   **Real-time News:** Fetches top headlines from the US.
*   **Search:** Search for articles by keyword.
*   **Category Filtering:** Filter news by categories like Business, Technology, Sports, etc.
*   **Offline Mode:** Caches headlines for offline viewing.
*   **Dark Mode:** Full dark theme support.
*   **Saved Articles:** Bookmark articles for later reading.
*   **In-App Browser:** Read full articles without leaving the app.

## Requirements

*   **Flutter SDK:** `>=3.10.4`
*   **Dart SDK:** `>=3.0.0`

## Setup & Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/news_grid.git
    cd news_grid
    ```

2.  **Get an API Key:**
    *   Sign up at [NewsAPI.org](https://newsapi.org/) to get a free API key.

3.  **Configure Environment Variables:**
    *   Create a file named `app_secrets.env` in the root directory (same level as `pubspec.yaml`).
    *   Add your API key to this file:
        ```env
        API_KEY=your_api_key_here
        ```

4.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

5.  **Run the App:**
    ```bash
    flutter run
    ```
    *   **Release Build (Android):**
        ```bash
        flutter build apk --release
        ```

## Troubleshooting

### API Rate Limit Exceeded
If you encounter a `Rate Limit Exceeded` message or an error with code `429` (Top Headlines) or `426` (Everything), it means you have exhausted your API key's request quota.

**NewsAPI Developer Plan Limits:**
*   **100 requests per day** (50 requests available every 12 hours).

The app handles this by showing a rate limit error screen. To resolve this:
*   Wait for the 12-hour reset period.
*   Upgrade to a paid plan on NewsAPI.org.
*   Or use a different API key in your `app_secrets.env` file.

```json
{
    "status": "error",
    "code": "rateLimited",
    "message": "You have made too many requests recently. Developer accounts are limited to 100 requests over a 24 hour period (50 requests available every 12 hours). Please upgrade to a paid plan if you need more requests."
}
```

## 3rd Party Packages Used

This project leverages several powerful packages from pub.dev:

*   **Network & Data:**
    *   [`dio`](https://pub.dev/packages/dio): fetching data from the internet.
    *   [`flutter_dotenv`](https://pub.dev/packages/flutter_dotenv): Loading environment variables.
    *   [`internet_connection_checker_plus`](https://pub.dev/packages/internet_connection_checker_plus): Checking internet connectivity.
    *   [`shared_preferences`](https://pub.dev/packages/shared_preferences): Local data persistence.

*   **State Management:**
    *   [`flutter_bloc`](https://pub.dev/packages/flutter_bloc): Implementing BLoC pattern for state management.
    *   [`get_it`](https://pub.dev/packages/get_it): Dependency injection.

*   **UI & Assets:**
    *   [`cached_network_image`](https://pub.dev/packages/cached_network_image): Efficient image loading and caching.
    *   [`skeletonizer`](https://pub.dev/packages/skeletonizer): Loading skeleton animations.
    *   [`font_awesome_flutter`](https://pub.dev/packages/font_awesome_flutter): Modern icons.
    *   [`webview_flutter`](https://pub.dev/packages/webview_flutter): In-app web browser.
    *   [`url_launcher`](https://pub.dev/packages/url_launcher): Launching external URLs.
    *   [`cupertino_icons`](https://pub.dev/packages/cupertino_icons): iOS style icons.

*   **Utilities:**
    *   [`intl`](https://pub.dev/packages/intl): Date and number formatting.
    *   [`share_plus`](https://pub.dev/packages/share_plus): Sharing content.
    *   [`pretty_dio_logger`](https://pub.dev/packages/pretty_dio_logger): Logging network requests.
    *   [`fpdart`](https://pub.dev/packages/fpdart): Functional programming helper.
