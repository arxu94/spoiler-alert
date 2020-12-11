json.merge! @recipe
json.instructions strip_tags(@recipe['instructions'])
json.summary strip_tags(@recipe['summary'])
