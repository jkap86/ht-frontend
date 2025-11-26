# API Infrastructure

## Error Handling

The `ApiClient` class automatically handles HTTP errors and throws typed exceptions. All API client implementations that use `ApiClient` benefit from this error handling.

### Exception Types

- `UnauthorizedException` (401) - User not authenticated
- `ForbiddenException` (403) - User lacks permission
- `NotFoundException` (404) - Resource not found
- `ValidationException` (400) - Request validation failed
- `ServerException` (5xx) - Server error
- `NetworkException` - Network connectivity issue
- `TimeoutException` - Request timeout
- `UnknownApiException` - Unexpected error

### How It Works

When any HTTP method (`postJson`, `getJson`, etc.) is called:
1. The request is executed
2. If the status code is >= 400, `ApiClient` throws an appropriate exception
3. The exception contains the status code, error message, and response body
4. If successful (status < 400), the response is returned

This means API client implementations don't need to check `response.statusCode` - if they receive a response, it's guaranteed to be successful.

### Example Usage

```dart
// API Client automatically throws exceptions
try {
  final response = await _apiClient.getJson('/api/resource', token: token);
  final data = jsonDecode(response.body);
  return MyDto.fromJson(data);
} on UnauthorizedException {
  // Handle authentication error
} on ValidationException catch (e) {
  // Handle validation error
  print(e.validationErrors);
} on ApiException catch (e) {
  // Handle any other API error
  print('${e.message} (${e.statusCode})');
}
```

### Domain-Specific Exceptions

Some API clients (like `AuthApiClient`) convert core API exceptions to domain-specific exceptions. This provides better semantics for the domain layer:

```dart
try {
  final response = await _apiClient.postJson('/api/auth/login', body: credentials);
  return AuthResultDto.fromJson(jsonDecode(response.body));
} on api.UnauthorizedException catch (e) {
  throw InvalidCredentialsException(e.message);
} on api.ApiException catch (e) {
  throw AuthException(e.message);
}
```

## Migration Notes

Existing API clients may have redundant status code checks like:

```dart
if (response.statusCode == 200) {
  return parseData(response.body);
} else {
  throw Exception('Failed: ${response.statusCode}');
}
```

These checks are now unnecessary (but harmless). The simplified version is:

```dart
// ApiClient throws if statusCode >= 400, so we only get here on success
return parseData(response.body);
```

The redundant checks can be removed over time for cleaner code.
