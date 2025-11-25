---
description: Generate markdown documentation in the docs/ directory
argument-hint: name | description
args:
  - name: name
    description: Suggested filename for the documentation (without .md extension)
    required: true
  - name: description
    description: What to document and how to structure it. Can include subdirectory path (e.g., "save in docs/api/")
    required: true
---
# Command Description

You are tasked with creating well-structured markdown documentation for this project.

## Documentation Requirements

**Filename**: {{name}}
**Content Description**: {{description}}

## Implementation Steps

1. **Determine the file location**:
   - Default location: `docs/{{name}}.md`
   - If description mentions a subdirectory (e.g., "save in docs/api/"), create: `docs/api/{{name}}.md`
   - Create any necessary subdirectories inside `docs/`

2. **Analyze the description**:
   - Identify what needs to be documented
   - Determine appropriate structure and sections
   - Note any specific formatting requirements mentioned
   - Use the suggested name unless description explicitly requires different naming

3. **Create the markdown file** (`docs/[path]/{{name}}.md`):
   - Start with a clear H1 title
   - Use logical heading hierarchy (H2, H3, etc.)
   - Include relevant sections based on content type:
     - Overview/Introduction
     - Key concepts or features
     - Code examples (if applicable)
     - Usage instructions (if applicable)
     - Additional notes or references
   - Use proper markdown formatting:
     - Code blocks with language specification
     - Lists for multiple items
     - Tables for structured data
     - Links to related documentation

4. **Content Guidelines**:
   - Write clear, concise explanations
   - Include practical examples where relevant
   - Use consistent terminology
   - Add code snippets with proper syntax highlighting
   - Keep it scannable with good use of headers and whitespace

## Best Practices to Follow

- **Clarity**: Write for your audience - assume reasonable technical knowledge but explain complex concepts
- **Structure**: Use clear sections with descriptive headers
- **Examples**: Include real-world examples and code snippets where applicable
- **Consistency**: Match the tone and style of existing documentation in the project
- **Completeness**: Cover the what, why, and how of the topic

## Output Format

After completing the task, provide:

1. Confirmation of file creation with full path
2. Brief summary of what was documented
3. Table of contents or key sections included
4. Any suggestions for related documentation that might be helpful

## Example Usage

**Simple case:**

```text
name: "api-endpoints"
description: "Document all REST API endpoints with request/response examples"
→ Creates: docs/api-endpoints.md
```

**With subdirectory:**

```text
name: "jwt-auth"
description: "Document JWT authentication flow. Save in docs/architecture/"
→ Creates: docs/architecture/jwt-auth.md
```
