INSERT INTO mailer_lists (id, name)
VALUES (1, 'identity');
INSERT INTO mailer_templates (mailing_list_id, name, contents)
VALUES (1, 'login', '<!doctype html>\n<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"></head><body>Click <a href="https://memberlist.internal.acm.umn.edu/login/{{uuid}}">here</a> to log in.</body></html>');
