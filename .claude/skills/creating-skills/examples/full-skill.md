---
name: example-skill
description: Example skill showing correct structure and frontmatter usage.
disable-model-invocation: true
allowed-tools: Read, Grep
argument-hint: [component-name]
globs: ["src/components/**/*.tsx"]
---

# Component Generator

Generate a new React component following project conventions.

## Steps

1. Create component file at `src/components/$ARGUMENTS.tsx`
2. Add unit test at `src/components/__tests__/$ARGUMENTS.test.tsx`
3. Export from `src/components/index.ts`

## Additional resources

- For the component template, see [templates/component.tsx](templates/component.tsx)
- For test examples, see [examples/test-sample.tsx](examples/test-sample.tsx)

## Rules

- Use functional components with TypeScript
- Export as named export, not default
- Include JSDoc comment above the component

## Anti-patterns

- ❌ Class components
- ❌ Default exports
- ❌ Missing TypeScript types
