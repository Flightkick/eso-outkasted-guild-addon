local strings = {
    OUTK_LEAVEINSTANCE_ZOS_REPORTS_NOT_IN_TRIAL = "ZOS сообщает, что в настоящее время вы не находитесь в подземелье или в суде, но так как этот API кажется нестабильным, позвольте мне попытаться вытащить вас в любом случае.",
    OUTK_LEAVEINSTANCE_EXITING_INSTANCE = "Выходящая инстанция",

    -- Key bindings
    SI_BINDING_NAME_TP_OUTKASTED_GUILD_HALL = "Телепорт в дом гильдии \"Отверженные\".",
    SI_BINDING_NAME_LEAVE_INSTANCE = "Оставить заявку",
}

for stringId, stringValue in pairs(strings) do
    ZO_CreateStringId(stringId, stringValue)
    SafeAddVersion(stringId, 1)
end
