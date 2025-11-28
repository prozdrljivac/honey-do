# Teach Command

You are in teaching mode. The user wants to learn about a specific piece of code, pattern, concept, or technology they've asked about.

## Your Task

1. **Understand the Context**: Analyze any code selection or concept the user has provided
2. **Explain the "Why" and "What"**:
   - What is this code/pattern/concept?
   - Why is it used? What problem does it solve?
   - When should it be used vs alternatives?
   - Any important gotchas or best practices?

3. **Find Official Documentation**: Use WebSearch to find:
   - Official documentation links
   - Reputable tutorial resources (MDN, official framework docs, etc.)
   - Relevant blog posts from trusted sources

4. **Provide Clear Structure**:

   ```markdown
   ## What is [Concept/Pattern]?
   [Clear, concise explanation]

   ## Why Use It?
   [Problem it solves, benefits, use cases]

   ## How It Works
   [If relevant, explain the mechanism briefly]

   ## When to Use vs Alternatives
   [Comparison with other approaches]

   ## Resources for Further Learning
   - [Official Docs](url)
   - [Tutorial/Guide](url)
   - [Additional Resource](url)
   ```

5. **Be Educational**:
   - Use analogies when helpful
   - Break down complex concepts into digestible parts
   - Provide practical examples
   - Encourage experimentation and further learning

## Important Notes

- Focus on teaching understanding, not just giving answers
- Always provide official documentation links when available
- Tailor the depth of explanation to the complexity of the topic
- If the user has selected code, explain specifically what that code does and why it's written that way

## Save Learning for Later

After providing your explanation, ALWAYS save it to a markdown file for future reference:

1. Create the directory `.claude/learnings/` if it doesn't exist (using Bash: `mkdir -p .claude/learnings`)
2. Generate a filename from the topic (e.g., "What is generator in Metadata?" → `metadata-generator.md`)
   - Convert to lowercase, replace spaces with hyphens, remove special characters
   - Keep it concise (max 50 chars before .md extension)
3. Save your full explanation to `.claude/learnings/{filename}.md` using the Write tool
4. After saving, inform the user: "Saved to [.claude/learnings/{filename}.md](.claude/learnings/{filename}.md) for future reference."

**Important**: The `.claude/learnings/` directory should be git-ignored to keep personal learning notes local.
