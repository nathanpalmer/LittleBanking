process Delete:
  input "SQL", Command = """
    DELETE FROM tbmTag WHERE Name like 'tag%'
  """