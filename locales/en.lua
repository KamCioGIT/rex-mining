local Translations = {

    client = {
        lang_1 = '',
    },

    server = {
        lang_1 = '',
    },

}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})

-- Lang:t('client.lang_1')
-- Lang:t('server.lang_1')
