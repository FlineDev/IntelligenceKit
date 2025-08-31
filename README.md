[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FFlineDev%2FIntelligenceKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/FlineDev/IntelligenceKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FFlineDev%2FIntelligenceKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/FlineDev/IntelligenceKit)

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

### Basic Text Generation
```swift
import IntelligenceKit

let openAI = OpenAI(apiKey: "your-key")

// Simple text generation with GPT-5-mini (medium reasoning by default)
let response = try await openAI.ask(
    model: .gpt5Mini(reasoning: .medium),
    input: "Write a haiku about coding"
)

// Get the response text with proper error handling
let text = try response.textMessage()
print(text)

// Advanced reasoning with specific effort level
let response2 = try await openAI.ask(
    model: .gpt5(reasoning: .high),
    instructions: "You are a helpful coding assistant",
    input: "Explain the benefits of Swift's type system",
    verbosity: .high
)
let detailedText = try response2.textMessage()
print(detailedText)
```

### Reasoning and Verbosity Options
```swift
// Reasoning effort levels (specified in model)
.gpt5Mini(reasoning: .minimal)  // Fastest, fewer reasoning tokens
.gpt5Mini(reasoning: .low)      // Balanced speed and reasoning
.gpt5Mini(reasoning: .medium)   // Default, good balance
.gpt5Mini(reasoning: .high)     // Most thorough reasoning

// Text verbosity levels (as parameter)
verbosity: .low      // Concise responses
verbosity: .medium   // Default length
verbosity: .high     // Detailed explanations
```

### Multi-turn Conversations
```swift
// First message
let response1 = try await openAI.ask(
    model: .gpt5Mini(reasoning: .medium),
    input: "What is Swift?"
)
let firstAnswer = try response1.textMessage()

// Continue conversation (automatic context)
let response2 = try await openAI.ask(
    model: .gpt5Mini(reasoning: .low),
    input: "How does it compare to Objective-C?",
    previousResponseID: response1.id
)
let followUpAnswer = try response2.textMessage()
```

### Structured JSON Output
```swift
// Define your data structure
struct Person: Codable {
    let name: String
    let age: Int
    let occupation: String
}

// Create JSON schema for structured output
let responseFormat = OpenAI.ResponseFormat(
    name: "PersonInfo",
    description: "Generate person information",
    schema: .object(
        properties: [
            "name": .string(description: "Person's full name"),
            "age": .integer(description: "Person's age in years"),
            "occupation": .string(description: "Person's job title")
        ]
    )
)

// Request structured JSON response
let response = try await openAI.ask(
    model: .gpt5Mini(reasoning: .low),
    input: "Generate a random person with a creative occupation",
    responseFormat: responseFormat
)

// Decode JSON directly into your type
let person = try response.jsonMessage(decodedTo: Person.self)
print("\(person.name) is \(person.age) years old and works as a \(person.occupation)")
```

### Image Generation with DALL-E
```swift
// Generate an image with DALL-E 3
let imageRequest = OpenAI.ImageRequest(
    prompt: "A serene Japanese garden with cherry blossoms at sunset",
    model: .dallE3,
    quality: .hd,
    style: .natural
)

let imageResponse = try await openAI.createImage(request: imageRequest)
if let imageURL = imageResponse.data.first?.url {
    print("Generated image: \(imageURL)")
}
```

## Dependencies

- [HandySwift](https://github.com/FlineDev/HandySwift) - REST client and utilities
- [ErrorKit](https://github.com/FlineDev/ErrorKit) - Typed error handling

## Error Handling

All functions use typed throws (`throws(OpenAI.Error)`) for better error handling. Errors conform to ErrorKit's `Throwable` protocol with localized user-friendly messages:

```swift
do {
    let response = try await openAI.ask(
        model: .gpt5Mini(reasoning: .medium),
        input: "Hello!"
    )
    let message = try response.textMessage()  // Throws if no content
    print(message)
} catch {
    print(error.userFriendlyMessage)  // Localized error message
    switch error {
    case .emptyResponse:
        print("No response content received")
    case .jsonSchemaDecodingError(let decodingError):
        print("Failed to decode JSON: \(decodingError)")
    case .requestError(let underlyingError):
        print("Request failed: \(underlyingError)")
    }
}
```

## Token Usage and Cost Tracking

```swift
let response = try await openAI.ask(
    model: .gpt5Mini(reasoning: .medium),
    input: "Explain quantum computing"
)

// Access token usage information
let usage = response.usage
print("Input tokens: \(usage.inputTokens)")
print("Output tokens: \(usage.outputTokens)")
print("Total tokens: \(usage.totalTokens)")

// Calculate approximate cost (prices are examples)
let inputCost = Double(usage.inputTokens) * 0.15 / 1_000_000  // $0.15 per million
let outputCost = Double(usage.outputTokens) * 0.60 / 1_000_000  // $0.60 per million
print("Estimated cost: $\(String(format: "%.4f", inputCost + outputCost))")
```

## Cross-Platform Notes

- **Linux Deployment**: Fully supported for server-side Swift applications
- **API Compatibility**: Identical API surface across all platforms

## Showcase

I extracted this library from my following Indie apps (rate them with 5 stars to thank me!):

<table>
  <tr>
    <th>App Icon</th>
    <th>App Name & Description</th>
    <th>Supported Platforms</th>
  </tr>
  <tr>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6476773066?pt=549314&ct=github.com&mt=8">
        <img src="https://raw.githubusercontent.com/FlineDev/HandySwift/main/Images/Apps/TranslateKit.webp" width="64" />
      </a>
    </td>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6476773066?pt=549314&ct=github.com&mt=8">
        <strong>TranslateKit: App Localizer</strong>
      </a>
      <br />
      Simple drag & drop translation of String Catalog files with support for multiple translation services & smart correctness checks.
    </td>
    <td>Mac</td>
  </tr>
  <tr>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6587583340?pt=549314&ct=github.com&mt=8">
        <img src="https://raw.githubusercontent.com/FlineDev/HandySwift/main/Images/Apps/PleydiaOrganizer.webp" width="64" />
      </a>
    </td>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6587583340?pt=549314&ct=github.com&mt=8">
        <strong>Pleydia Organizer: Movie & Series Renamer</strong>
      </a>
      <br />
      Simple, fast, and smart media management for your Movie, TV Show and Anime collection.
    </td>
    <td>Mac</td>
  </tr>
  <tr>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6502914189?pt=549314&ct=github.com&mt=8">
        <img src="https://raw.githubusercontent.com/FlineDev/HandySwift/main/Images/Apps/FreemiumKit.webp" width="64" />
      </a>
    </td>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6502914189?pt=549314&ct=github.com&mt=8">
        <strong>FreemiumKit: In-App Purchases</strong>
      </a>
      <br />
      Simple In-App Purchases and Subscriptions for Apple Platforms: Automation, Paywalls, A/B Testing, Live Notifications, PPP, and more.
    </td>
    <td>iPhone, iPad, Mac, Vision</td>
  </tr>
  <tr>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6480134993?pt=549314&ct=github.com&mt=8">
        <img src="https://raw.githubusercontent.com/FlineDev/HandySwift/main/Images/Apps/FreelanceKit.webp" width="64" />
      </a>
    </td>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6480134993?pt=549314&ct=github.com&mt=8">
        <strong>FreelanceKit: Time Tracking</strong>
      </a>
      <br />
      Simple & affordable time tracking with a native experience for all  devices. iCloud sync & CSV export included.
    </td>
    <td>iPhone, iPad, Mac, Vision</td>
  </tr>
  <tr>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6472669260?pt=549314&ct=github.com&mt=8">
        <img src="https://raw.githubusercontent.com/FlineDev/HandySwift/main/Images/Apps/CrossCraft.webp" width="64" />
      </a>
    </td>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6472669260?pt=549314&ct=github.com&mt=8">
        <strong>CrossCraft: Custom Crosswords</strong>
      </a>
      <br />
      Create themed & personalized crosswords. Solve them yourself or share them to challenge others.
    </td>
    <td>iPhone, iPad, Mac, Vision</td>
  </tr>
  <tr>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6477829138?pt=549314&ct=github.com&mt=8">
        <img src="https://raw.githubusercontent.com/FlineDev/HandySwift/main/Images/Apps/FocusBeats.webp" width="64" />
      </a>
    </td>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6477829138?pt=549314&ct=github.com&mt=8">
        <strong>FocusBeats: Pomodoro + Music</strong>
      </a>
      <br />
      Deep Focus with proven Pomodoro method & select Apple Music playlists & themes. Automatically pauses music during breaks.
    </td>
    <td>iPhone, iPad, Mac, Vision</td>
  </tr>
  <tr>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6478062053?pt=549314&ct=github.com&mt=8">
        <img src="https://raw.githubusercontent.com/FlineDev/HandySwift/main/Images/Apps/Posters.webp" width="64" />
      </a>
    </td>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6478062053?pt=549314&ct=github.com&mt=8">
        <strong>Posters: Discover Movies at Home</strong>
      </a>
      <br />
      Auto-updating & interactive posters for your home with trailers, showtimes, and links to streaming services.
    </td>
    <td>Vision</td>
  </tr>
</table>