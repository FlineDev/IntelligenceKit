# IntelligenceKit

Unified Swift package for OpenAI API integration with GPT-5 support and advanced reasoning capabilities.

## Platform Support

- **Apple Platforms**: iOS 18+, macOS 15+, tvOS 18+, visionOS 2+, watchOS 11+
- **Linux**: Full server-side Swift support for deployment on Linux servers

## Features

- **OpenAI GPT-5 family**: GPT-5, GPT-5-mini, GPT-5-nano with reasoning capabilities
- **Legacy model support**: GPT-4.1, o3, o4-mini for comparison and migration
- **Advanced reasoning**: Multiple reasoning effort levels (minimal, low, medium, high)
- **Responses API**: Modern OpenAI API with better performance and lower costs
- **Cross-platform compatibility**: Apple platforms + Linux server support
- **ErrorKit integration**: Localized error messages with typed error handling
- **Structured response parsing**: JSON Schema support for data extraction
- **Multi-turn conversations**: Automatic conversation state management
- **Pricing transparency**: Built-in cost tracking and optimization

## Usage

### Basic Usage with GPT-5
```swift
import IntelligenceKit

let openAI = OpenAI(apiKey: "your-key")

// Simple text generation with GPT-5-mini
let response = try await openAI.ask(
    model: .gpt5Mini,
    input: "Write a haiku about coding"
)
print(response.outputText)

// Advanced reasoning with specific effort level
let response = try await openAI.ask(
    model: .gpt5,
    instructions: "You are a helpful coding assistant",
    input: "Explain the benefits of Swift's type system",
    reasoning: .high,
    verbosity: .high
)
```

### Reasoning and Verbosity Options
```swift
// Reasoning effort levels
reasoning: .minimal  // Fastest, fewer reasoning tokens
reasoning: .low      // Balanced speed and reasoning
reasoning: .medium   // Default, good balance
reasoning: .high     // Most thorough reasoning

// Text verbosity levels  
verbosity: .low      // Concise responses
verbosity: .medium   // Default length
verbosity: .high     // Detailed explanations
```

### Multi-turn Conversations
```swift
// First message
let response1 = try await openAI.ask(
    model: .gpt5Mini,
    input: "What is Swift?"
)

// Continue conversation (automatic context)
let response2 = try await openAI.ask(
    model: .gpt5Mini,
    input: "How does it compare to Objective-C?",
    previousResponseID: response1.id
)
```

## Dependencies

- [HandySwift](https://github.com/FlineDev/HandySwift) - REST client and utilities
- [ErrorKit](https://github.com/FlineDev/ErrorKit) - Typed error handling

## Error Handling

All errors conform to ErrorKit's `Throwable` protocol with localized user-friendly messages:

```swift
do {
    let response = try await openAI.chatCompletion(...)
} catch let error as OpenAI.Error {
    print(error.userFriendlyMessage) // Localized error message
}
```

## Cross-Platform Notes

- **Linux Deployment**: Fully supported for server-side Swift applications
- **API Compatibility**: Identical API surface across all platforms