import { defineCollection, z } from 'astro:content'
const taskCollection = defineCollection({
  schema: z.object({
    title: z.string(),
    description: z.string(),
  }),
})
export const collections = {
  tasks: taskCollection,
}
