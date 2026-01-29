// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'MeshCore Open';

  @override
  String get nav_contacts => '联系人';

  @override
  String get nav_channels => '频道';

  @override
  String get nav_map => '地图';

  @override
  String get common_cancel => '取消';

  @override
  String get common_ok => '好的';

  @override
  String get common_connect => '连接';

  @override
  String get common_unknownDevice => '未知设备';

  @override
  String get common_save => '保存';

  @override
  String get common_delete => '删除';

  @override
  String get common_close => '关闭';

  @override
  String get common_edit => '编辑';

  @override
  String get common_add => '添加';

  @override
  String get common_settings => '设置';

  @override
  String get common_disconnect => '断开';

  @override
  String get common_connected => '已连接';

  @override
  String get common_disconnected => '断开';

  @override
  String get common_create => '创建';

  @override
  String get common_continue => '继续';

  @override
  String get common_share => '分享';

  @override
  String get common_copy => '复制';

  @override
  String get common_retry => '重试';

  @override
  String get common_hide => '隐藏';

  @override
  String get common_remove => '删除';

  @override
  String get common_enable => '启用';

  @override
  String get common_disable => '禁用';

  @override
  String get common_reboot => '重启';

  @override
  String get common_loading => '正在加载...';

  @override
  String get common_notAvailable => '—';

  @override
  String common_voltageValue(String volts) {
    return '$volts V';
  }

  @override
  String common_percentValue(int percent) {
    return '$percent%';
  }

  @override
  String get scanner_title => 'MeshCore Open';

  @override
  String get scanner_scanning => '扫描设备…';

  @override
  String get scanner_connecting => '连接中...';

  @override
  String get scanner_disconnecting => '断开中...';

  @override
  String get scanner_notConnected => '未连接';

  @override
  String scanner_connectedTo(String deviceName) {
    return '已连接至 $deviceName';
  }

  @override
  String get scanner_searchingDevices => '搜索 MeshCore 设备...';

  @override
  String get scanner_tapToScan => '点击扫描以查找MeshCore设备';

  @override
  String scanner_connectionFailed(String error) {
    return '连接失败：$error';
  }

  @override
  String get scanner_stop => '停止';

  @override
  String get scanner_scan => '扫描';

  @override
  String get device_quickSwitch => '快速切换';

  @override
  String get device_meshcore => 'MeshCore';

  @override
  String get settings_title => '设置';

  @override
  String get settings_deviceInfo => '设备信息';

  @override
  String get settings_appSettings => '应用设置';

  @override
  String get settings_appSettingsSubtitle => '通知、消息和地图偏好';

  @override
  String get settings_nodeSettings => '节点设置';

  @override
  String get settings_nodeName => '节点名称';

  @override
  String get settings_nodeNameNotSet => '未设置';

  @override
  String get settings_nodeNameHint => '请输入节点名称';

  @override
  String get settings_nodeNameUpdated => '姓名已更新';

  @override
  String get settings_radioSettings => '无线设置';

  @override
  String get settings_radioSettingsSubtitle => '频率，功率，扩展因子';

  @override
  String get settings_radioSettingsUpdated => '射频设置已更新';

  @override
  String get settings_location => '位置';

  @override
  String get settings_locationSubtitle => 'GPS坐标';

  @override
  String get settings_locationUpdated => '位置已更新';

  @override
  String get settings_locationBothRequired => '请输入纬度和经度。';

  @override
  String get settings_locationInvalid => '无效的纬度或经度。';

  @override
  String get settings_locationGPSEnable => '启用GPS';

  @override
  String get settings_locationGPSEnableSubtitle => '启用GPS自动更新位置。';

  @override
  String get settings_locationIntervalSec => 'GPS 间隔（秒）';

  @override
  String get settings_locationIntervalInvalid => '时间间隔必须至少为60秒，且小于86400秒。';

  @override
  String get settings_latitude => '纬度';

  @override
  String get settings_longitude => '经度';

  @override
  String get settings_privacyMode => '隐私模式';

  @override
  String get settings_privacyModeSubtitle => '隐藏在广告中的姓名/位置';

  @override
  String get settings_privacyModeToggle => '开启隐私模式以隐藏您的姓名和位置在广告中的显示。';

  @override
  String get settings_privacyModeEnabled => '隐私模式已启用';

  @override
  String get settings_privacyModeDisabled => '隐私模式已禁用';

  @override
  String get settings_actions => '操作';

  @override
  String get settings_sendAdvertisement => '发送广告';

  @override
  String get settings_sendAdvertisementSubtitle => '现在已广播';

  @override
  String get settings_advertisementSent => '广告已发送';

  @override
  String get settings_syncTime => '同步时间';

  @override
  String get settings_syncTimeSubtitle => '将设备时钟设置为手机时间';

  @override
  String get settings_timeSynchronized => '时间同步';

  @override
  String get settings_refreshContacts => '刷新联系人';

  @override
  String get settings_refreshContactsSubtitle => '从设备重新加载联系人列表';

  @override
  String get settings_rebootDevice => '重启设备';

  @override
  String get settings_rebootDeviceSubtitle => '重启 MeshCore 设备';

  @override
  String get settings_rebootDeviceConfirm => '您确定要重启设备吗？您将会断开连接。';

  @override
  String get settings_debug => '调试';

  @override
  String get settings_bleDebugLog => '蓝牙调试日志';

  @override
  String get settings_bleDebugLogSubtitle => '蓝牙命令、响应和原始数据';

  @override
  String get settings_appDebugLog => '应用调试日志';

  @override
  String get settings_appDebugLogSubtitle => '应用调试消息';

  @override
  String get settings_about => '关于';

  @override
  String settings_aboutVersion(String version) {
    return 'MeshCore Open v$version';
  }

  @override
  String get settings_aboutLegalese => '2024 MeshCore 开放源代码项目';

  @override
  String get settings_aboutDescription =>
      '一个开源的 Flutter 客户端，用于 MeshCore LoRa 网状网络设备。';

  @override
  String get settings_infoName => '姓名';

  @override
  String get settings_infoId => 'ID';

  @override
  String get settings_infoStatus => '状态';

  @override
  String get settings_infoBattery => '电池';

  @override
  String get settings_infoPublicKey => '公钥';

  @override
  String get settings_infoContactsCount => '联系人数量';

  @override
  String get settings_infoChannelCount => '频道数量';

  @override
  String get settings_presets => '预设';

  @override
  String get settings_preset915Mhz => '915 MHz';

  @override
  String get settings_preset868Mhz => '868 MHz';

  @override
  String get settings_preset433Mhz => '433 MHz';

  @override
  String get settings_frequency => '频率 (MHz)';

  @override
  String get settings_frequencyHelper => '300.0 - 2500.0';

  @override
  String get settings_frequencyInvalid => '无效频率 (300-2500 MHz)';

  @override
  String get settings_bandwidth => '带宽';

  @override
  String get settings_spreadingFactor => '扩散因子';

  @override
  String get settings_codingRate => '编码速率';

  @override
  String get settings_txPower => 'TX Power (dBm)';

  @override
  String get settings_txPowerHelper => '0 - 22';

  @override
  String get settings_txPowerInvalid => '无效的 TX 电功率 (0-22 dBm)';

  @override
  String get settings_longRange => '远距离';

  @override
  String get settings_fastSpeed => '快速速度';

  @override
  String settings_error(String message) {
    return '错误：$message';
  }

  @override
  String get appSettings_title => '应用设置';

  @override
  String get appSettings_appearance => '外观';

  @override
  String get appSettings_theme => '主题';

  @override
  String get appSettings_themeSystem => '系统默认';

  @override
  String get appSettings_themeLight => '光';

  @override
  String get appSettings_themeDark => '深色';

  @override
  String get appSettings_language => '语言';

  @override
  String get appSettings_languageSystem => '系统默认';

  @override
  String get appSettings_languageEn => 'English';

  @override
  String get appSettings_languageFr => 'Français';

  @override
  String get appSettings_languageEs => 'Español';

  @override
  String get appSettings_languageDe => 'Deutsch';

  @override
  String get appSettings_languagePl => 'Polski';

  @override
  String get appSettings_languageSl => 'Slovenščina';

  @override
  String get appSettings_languagePt => 'Português';

  @override
  String get appSettings_languageIt => 'Italiano';

  @override
  String get appSettings_languageZh => '中文';

  @override
  String get appSettings_languageSv => 'Svenska';

  @override
  String get appSettings_languageNl => 'Nederlands';

  @override
  String get appSettings_languageSk => 'Slovenčina';

  @override
  String get appSettings_languageBg => 'Български';

  @override
  String get appSettings_notifications => '通知';

  @override
  String get appSettings_enableNotifications => '启用通知';

  @override
  String get appSettings_enableNotificationsSubtitle => '接收消息和广告的通知';

  @override
  String get appSettings_notificationPermissionDenied => '通知权限被拒绝';

  @override
  String get appSettings_notificationsEnabled => '通知已启用';

  @override
  String get appSettings_notificationsDisabled => '通知已关闭';

  @override
  String get appSettings_messageNotifications => '消息通知';

  @override
  String get appSettings_messageNotificationsSubtitle => '显示收到新消息时的通知';

  @override
  String get appSettings_channelMessageNotifications => '频道消息通知';

  @override
  String get appSettings_channelMessageNotificationsSubtitle => '显示接收频道消息时的通知';

  @override
  String get appSettings_advertisementNotifications => '广告通知';

  @override
  String get appSettings_advertisementNotificationsSubtitle => '显示当新节点被发现时通知';

  @override
  String get appSettings_messaging => '消息';

  @override
  String get appSettings_clearPathOnMaxRetry => '清除最大重试路径';

  @override
  String get appSettings_clearPathOnMaxRetrySubtitle => '重置联系人路径，在5次发送失败尝试后';

  @override
  String get appSettings_pathsWillBeCleared => '路径将在5次失败重试后清除';

  @override
  String get appSettings_pathsWillNotBeCleared => '路径不会自动清理';

  @override
  String get appSettings_autoRouteRotation => '自动路径旋转';

  @override
  String get appSettings_autoRouteRotationSubtitle => '在最佳路径和洪水模式之间切换';

  @override
  String get appSettings_autoRouteRotationEnabled => '自动路径轮换已启用';

  @override
  String get appSettings_autoRouteRotationDisabled => '自动路径轮换已禁用';

  @override
  String get appSettings_battery => '电池';

  @override
  String get appSettings_batteryChemistry => '电池化学';

  @override
  String appSettings_batteryChemistryPerDevice(String deviceName) {
    return '设置每个设备 ($deviceName)';
  }

  @override
  String get appSettings_batteryChemistryConnectFirst => '连接设备以选择';

  @override
  String get appSettings_batteryNmc => '18650 NMC (3.0-4.2V)';

  @override
  String get appSettings_batteryLifepo4 => '磷酸铁锂 (2.6-3.65V)';

  @override
  String get appSettings_batteryLipo => 'LiPo (3.0-4.2V)';

  @override
  String get appSettings_mapDisplay => '地图显示';

  @override
  String get appSettings_showRepeaters => '显示循环器';

  @override
  String get appSettings_showRepeatersSubtitle => '在地图上显示重复节点';

  @override
  String get appSettings_showChatNodes => '显示聊天节点';

  @override
  String get appSettings_showChatNodesSubtitle => '在地图上显示聊天节点';

  @override
  String get appSettings_showOtherNodes => '显示其他节点';

  @override
  String get appSettings_showOtherNodesSubtitle => '显示其他节点类型在地图上';

  @override
  String get appSettings_timeFilter => '时间筛选';

  @override
  String get appSettings_timeFilterShowAll => '显示所有节点';

  @override
  String appSettings_timeFilterShowLast(int hours) {
    return '显示来自过去 $hours 小时的节点';
  }

  @override
  String get appSettings_mapTimeFilter => '地图时间筛选';

  @override
  String get appSettings_showNodesDiscoveredWithin => '显示发现的节点在：';

  @override
  String get appSettings_allTime => '所有时间';

  @override
  String get appSettings_lastHour => '最后小时';

  @override
  String get appSettings_last6Hours => '最后6小时';

  @override
  String get appSettings_last24Hours => '最后24小时';

  @override
  String get appSettings_lastWeek => '上周';

  @override
  String get appSettings_offlineMapCache => '离线地图缓存';

  @override
  String get appSettings_noAreaSelected => '未选择任何区域';

  @override
  String appSettings_areaSelectedZoom(int minZoom, int maxZoom) {
    return '选中的区域（缩放至 $minZoom - $maxZoom）';
  }

  @override
  String get appSettings_debugCard => '调试';

  @override
  String get appSettings_appDebugLogging => '应用调试日志';

  @override
  String get appSettings_appDebugLoggingSubtitle => '记录应用调试消息以供故障排除';

  @override
  String get appSettings_appDebugLoggingEnabled => '应用调试日志已启用';

  @override
  String get appSettings_appDebugLoggingDisabled => '应用调试日志已禁用';

  @override
  String get contacts_title => '联系人';

  @override
  String get contacts_noContacts => '还没有联系人';

  @override
  String get contacts_contactsWillAppear => '设备会广播时，联系人会显示';

  @override
  String get contacts_searchContacts => '搜索联系人...';

  @override
  String get contacts_noUnreadContacts => '未读联系人';

  @override
  String get contacts_noContactsFound => '未找到任何联系人或群组';

  @override
  String get contacts_deleteContact => '删除联系人';

  @override
  String contacts_removeConfirm(String contactName) {
    return '从联系人中删除 $contactName 吗？';
  }

  @override
  String get contacts_manageRepeater => '管理重复项';

  @override
  String get contacts_manageRoom => '管理房间服务器';

  @override
  String get contacts_roomLogin => '房间登录';

  @override
  String get contacts_openChat => '打开聊天';

  @override
  String get contacts_editGroup => '编辑组';

  @override
  String get contacts_deleteGroup => '删除分组';

  @override
  String contacts_deleteGroupConfirm(String groupName) {
    return '删除\"$groupName\"？';
  }

  @override
  String get contacts_newGroup => '新组';

  @override
  String get contacts_groupName => '组名';

  @override
  String get contacts_groupNameRequired => '组名不能为空';

  @override
  String contacts_groupAlreadyExists(String name) {
    return '组“$name”已存在';
  }

  @override
  String get contacts_filterContacts => '筛选联系人...';

  @override
  String get contacts_noContactsMatchFilter => '未找到匹配您的筛选条件的结果';

  @override
  String get contacts_noMembers => '没有会员';

  @override
  String get contacts_lastSeenNow => '最后一次登录时间现在';

  @override
  String contacts_lastSeenMinsAgo(int minutes) {
    return '最后一次出现 $minutes 分前';
  }

  @override
  String get contacts_lastSeenHourAgo => '最后一次出现前1小时';

  @override
  String contacts_lastSeenHoursAgo(int hours) {
    return '最后一次出现 $hours 小时前';
  }

  @override
  String get contacts_lastSeenDayAgo => '最后一次登录前一天';

  @override
  String contacts_lastSeenDaysAgo(int days) {
    return '最后一次出现 $days 天前';
  }

  @override
  String get channels_title => '频道';

  @override
  String get channels_noChannelsConfigured => '未配置任何频道';

  @override
  String get channels_addPublicChannel => '添加公开频道';

  @override
  String get channels_searchChannels => '搜索频道...';

  @override
  String get channels_noChannelsFound => '未找到任何频道';

  @override
  String channels_channelIndex(int index) {
    return '频道 $index';
  }

  @override
  String get channels_hashtagChannel => '话题频道';

  @override
  String get channels_public => '公开';

  @override
  String get channels_private => '私有';

  @override
  String get channels_publicChannel => '公开频道';

  @override
  String get channels_privateChannel => '私聊频道';

  @override
  String get channels_editChannel => '编辑频道';

  @override
  String get channels_deleteChannel => '删除频道';

  @override
  String channels_deleteChannelConfirm(String name) {
    return '删除\"$name\"？此操作无法撤销。';
  }

  @override
  String channels_channelDeleted(String name) {
    return '频道“$name”已删除';
  }

  @override
  String get channels_addChannel => '添加频道';

  @override
  String get channels_channelIndexLabel => '频道索引';

  @override
  String get channels_channelName => '频道名称';

  @override
  String get channels_usePublicChannel => '使用公共频道';

  @override
  String get channels_standardPublicPsk => '标准公钥共享密钥';

  @override
  String get channels_pskHex => 'PSK (十六进制)';

  @override
  String get channels_generateRandomPsk => '生成随机PSK';

  @override
  String get channels_enterChannelName => '请输入频道名称';

  @override
  String get channels_pskMustBe32Hex => 'PSK 必须是 32 个十六进制字符';

  @override
  String channels_channelAdded(String name) {
    return '频道“$name”已添加';
  }

  @override
  String channels_editChannelTitle(int index) {
    return '编辑频道 $index';
  }

  @override
  String get channels_smazCompression => 'SMAZ 压缩';

  @override
  String channels_channelUpdated(String name) {
    return '频道“$name”已更新';
  }

  @override
  String get channels_publicChannelAdded => '公共频道已添加';

  @override
  String get channels_sortBy => '按类型排序';

  @override
  String get channels_sortManual => '手动';

  @override
  String get channels_sortAZ => 'A-Z';

  @override
  String get channels_sortLatestMessages => '最新消息';

  @override
  String get channels_sortUnread => '未读';

  @override
  String get channels_createPrivateChannel => '创建私聊频道';

  @override
  String get channels_createPrivateChannelDesc => '使用密钥保护。';

  @override
  String get channels_joinPrivateChannel => '加入私密频道';

  @override
  String get channels_joinPrivateChannelDesc => '手动输入密钥。';

  @override
  String get channels_joinPublicChannel => '加入公共频道';

  @override
  String get channels_joinPublicChannelDesc => '任何人都可以加入这个频道。';

  @override
  String get channels_joinHashtagChannel => '加入标签频道';

  @override
  String get channels_joinHashtagChannelDesc => '任何人都可以加入话题频道。';

  @override
  String get channels_scanQrCode => '扫描二维码';

  @override
  String get channels_scanQrCodeComingSoon => '即将到来';

  @override
  String get channels_enterHashtag => '输入标签';

  @override
  String get channels_hashtagHint => '例如 #团队';

  @override
  String get chat_noMessages => '目前还没有消息';

  @override
  String get chat_sendMessageToStart => '发送消息开始';

  @override
  String get chat_originalMessageNotFound => '找不到原始消息';

  @override
  String chat_replyingTo(String name) {
    return '回复 $name';
  }

  @override
  String chat_replyTo(String name) {
    return '回复 $name';
  }

  @override
  String get chat_location => '位置';

  @override
  String chat_sendMessageTo(String contactName) {
    return '向$contactName发送消息';
  }

  @override
  String get chat_typeMessage => '输入消息...';

  @override
  String chat_messageTooLong(int maxBytes) {
    return '消息太长了（最大 $maxBytes 字节）。';
  }

  @override
  String get chat_messageCopied => '消息已复制';

  @override
  String get chat_messageDeleted => '消息已删除';

  @override
  String get chat_retryingMessage => '重试';

  @override
  String chat_retryCount(int current, int max) {
    return '重试 $current/$max';
  }

  @override
  String get chat_sendGif => '发送GIF';

  @override
  String get chat_reply => '回复';

  @override
  String get chat_addReaction => '添加反应';

  @override
  String get chat_me => '我';

  @override
  String get emojiCategorySmileys => '表情符号';

  @override
  String get emojiCategoryGestures => '手势';

  @override
  String get emojiCategoryHearts => '心';

  @override
  String get emojiCategoryObjects => '对象';

  @override
  String get gifPicker_title => '选择一个 GIF';

  @override
  String get gifPicker_searchHint => '搜索GIF...';

  @override
  String get gifPicker_poweredBy => '由 GIPHY 提供支持';

  @override
  String get gifPicker_noGifsFound => '未找到 GIF 动画';

  @override
  String get gifPicker_failedLoad => 'GIF 加载失败';

  @override
  String get gifPicker_failedSearch => '搜索GIF失败';

  @override
  String get gifPicker_noInternet => '无网络连接';

  @override
  String get debugLog_appTitle => '应用调试日志';

  @override
  String get debugLog_bleTitle => '蓝牙调试日志';

  @override
  String get debugLog_copyLog => '复制日志';

  @override
  String get debugLog_clearLog => '清除日志';

  @override
  String get debugLog_copied => '调试日志已复制';

  @override
  String get debugLog_bleCopied => '蓝牙日志复制';

  @override
  String get debugLog_noEntries => '尚未生成调试日志';

  @override
  String get debugLog_enableInSettings => '启用应用调试日志记录设置';

  @override
  String get debugLog_frames => '帧';

  @override
  String get debugLog_rawLogRx => '原始日志-RX';

  @override
  String get debugLog_noBleActivity => '目前还没有蓝牙活动。';

  @override
  String debugFrame_length(int count) {
    return '帧长度：$count 字节';
  }

  @override
  String debugFrame_command(String value) {
    return '命令：0x$value';
  }

  @override
  String get debugFrame_textMessageHeader => '短信框';

  @override
  String debugFrame_destinationPubKey(String pubKey) {
    return '- 目的地公钥：$pubKey';
  }

  @override
  String debugFrame_timestamp(int timestamp) {
    return '- 时间戳：$timestamp';
  }

  @override
  String debugFrame_flags(String value) {
    return '- 标志：0x$value';
  }

  @override
  String debugFrame_textType(int type, String label) {
    return '- 文本类型：$type ($label)';
  }

  @override
  String get debugFrame_textTypeCli => 'CLI';

  @override
  String get debugFrame_textTypePlain => '简洁';

  @override
  String debugFrame_text(String text) {
    return '- 文本：\"$text\"';
  }

  @override
  String get debugFrame_hexDump => '十六进制数据';

  @override
  String get chat_pathManagement => '路径管理';

  @override
  String get chat_routingMode => '路由模式';

  @override
  String get chat_autoUseSavedPath => '自动（使用已保存路径）';

  @override
  String get chat_forceFloodMode => '强制洪水模式';

  @override
  String get chat_recentAckPaths => '最近的 ACK 路径 (点击以使用):';

  @override
  String get chat_pathHistoryFull => '路径历史已满。删除条目以添加新条目。';

  @override
  String get chat_hopSingular => '跳转';

  @override
  String get chat_hopPlural => '跳跃';

  @override
  String chat_hopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '跳跃',
      one: '跳跃',
    );
    return '$count $_temp0';
  }

  @override
  String get chat_successes => '成功';

  @override
  String get chat_removePath => '删除路径';

  @override
  String get chat_noPathHistoryYet => '还没有历史记录。\n发送消息以发现路径。';

  @override
  String get chat_pathActions => '路径操作：';

  @override
  String get chat_setCustomPath => '设置自定义路径';

  @override
  String get chat_setCustomPathSubtitle => '手动指定路由路径';

  @override
  String get chat_clearPath => '清除路径';

  @override
  String get chat_clearPathSubtitle => '强制下次发送时重新发现';

  @override
  String get chat_pathCleared => '路径已清除。下一条消息将重新发现路线。';

  @override
  String get chat_floodModeSubtitle => '使用应用栏中的路由切换开关';

  @override
  String get chat_floodModeEnabled => '防洪模式已启用。通过应用程序栏中的路由图标进行反转。';

  @override
  String get chat_fullPath => '完整路径';

  @override
  String get chat_pathDetailsNotAvailable => '路径详情尚未获取。请尝试发送消息以刷新。';

  @override
  String chat_pathSetHops(int hopCount, String status) {
    String _temp0 = intl.Intl.pluralLogic(
      hopCount,
      locale: localeName,
      other: 'hops',
      one: 'hop',
    );
    return '路径设置：$hopCount $_temp0 - $status';
  }

  @override
  String get chat_pathSavedLocally => '已本地保存。连接以同步。';

  @override
  String get chat_pathDeviceConfirmed => '设备已确认。';

  @override
  String get chat_pathDeviceNotConfirmed => '设备尚未确认。';

  @override
  String get chat_type => '输入';

  @override
  String get chat_path => '路径';

  @override
  String get chat_publicKey => '公钥';

  @override
  String get chat_compressOutgoingMessages => '压缩发送的消息';

  @override
  String get chat_floodForced => '强制溢出';

  @override
  String get chat_directForced => '强制直接';

  @override
  String chat_hopsForced(int count) {
    return '$count 次跳跃 (强制)';
  }

  @override
  String get chat_floodAuto => '自动防洪';

  @override
  String get chat_direct => '直接';

  @override
  String get chat_poiShared => '共享位置信息';

  @override
  String chat_unread(int count) {
    return '未读：$count';
  }

  @override
  String get chat_openLink => '打开链接？';

  @override
  String get chat_openLinkConfirmation => '您想在浏览器中打开此链接吗？';

  @override
  String get chat_open => '打开';

  @override
  String chat_couldNotOpenLink(String url) {
    return '无法打开链接：$url';
  }

  @override
  String get chat_invalidLink => '链接格式无效';

  @override
  String get map_title => '节点地图';

  @override
  String get map_noNodesWithLocation => '没有具有位置数据的节点';

  @override
  String get map_nodesNeedGps => '节点需要共享它们的 GPS 坐标\n才能在地图上显示';

  @override
  String map_nodesCount(int count) {
    return '节点：$count';
  }

  @override
  String map_pinsCount(int count) {
    return '针：$count';
  }

  @override
  String get map_chat => '聊天';

  @override
  String get map_repeater => '重复器';

  @override
  String get map_room => '房间';

  @override
  String get map_sensor => '传感器';

  @override
  String get map_pinDm => '私信 (DM)';

  @override
  String get map_pinPrivate => '私密模式';

  @override
  String get map_pinPublic => '公开(公版)';

  @override
  String get map_lastSeen => '最后一次登录';

  @override
  String get map_disconnectConfirm => '您确定要断开与此设备的连接吗？';

  @override
  String get map_from => '从';

  @override
  String get map_source => '来源';

  @override
  String get map_flags => '旗帜';

  @override
  String get map_shareMarkerHere => '分享标记在此';

  @override
  String get map_pinLabel => '固定标签';

  @override
  String get map_label => '标签';

  @override
  String get map_pointOfInterest => '兴趣点';

  @override
  String get map_sendToContact => '发送给联系人';

  @override
  String get map_sendToChannel => '发送到频道';

  @override
  String get map_noChannelsAvailable => '没有可用的频道';

  @override
  String get map_publicLocationShare => '公共位置共享';

  @override
  String map_publicLocationShareConfirm(String channelLabel) {
    return '您即将分享一个位置在 $channelLabel。此频道公开，任何拥有 PSK 的人都可以看到它。';
  }

  @override
  String get map_connectToShareMarkers => '连接设备以共享标记';

  @override
  String get map_filterNodes => '筛选节点';

  @override
  String get map_nodeTypes => '节点类型';

  @override
  String get map_chatNodes => '聊天节点';

  @override
  String get map_repeaters => '重复器';

  @override
  String get map_otherNodes => '其他节点';

  @override
  String get map_keyPrefix => '键前缀';

  @override
  String get map_filterByKeyPrefix => '按关键词前缀筛选';

  @override
  String get map_publicKeyPrefix => '公钥前缀';

  @override
  String get map_markers => '标记';

  @override
  String get map_showSharedMarkers => '显示共享标记';

  @override
  String get map_lastSeenTime => '最后一次查看时间';

  @override
  String get map_sharedPin => '共享 PIN';

  @override
  String get map_joinRoom => '加入房间';

  @override
  String get map_manageRepeater => '管理重复项';

  @override
  String get mapCache_title => '离线地图缓存';

  @override
  String get mapCache_selectAreaFirst => '选择一个区域进行缓存';

  @override
  String get mapCache_noTilesToDownload => '该区域没有可下载的瓦片。';

  @override
  String get mapCache_downloadTilesTitle => '下载瓦片';

  @override
  String mapCache_downloadTilesPrompt(int count) {
    return '下载 $count 个瓦片用于离线使用？';
  }

  @override
  String get mapCache_downloadAction => '下载';

  @override
  String mapCache_cachedTiles(int count) {
    return '已缓存 $count 个瓦片';
  }

  @override
  String mapCache_cachedTilesWithFailed(int downloaded, int failed) {
    return '已缓存 $downloaded 个瓦片 ($failed 失败)';
  }

  @override
  String get mapCache_clearOfflineCacheTitle => '清除离线缓存';

  @override
  String get mapCache_clearOfflineCachePrompt => '删除所有缓存地图瓦片？';

  @override
  String get mapCache_offlineCacheCleared => '离线缓存已清除';

  @override
  String get mapCache_noAreaSelected => '未选择任何区域';

  @override
  String get mapCache_cacheArea => '缓存区域';

  @override
  String get mapCache_useCurrentView => '使用当前视图';

  @override
  String get mapCache_zoomRange => '缩放范围';

  @override
  String mapCache_estimatedTiles(int count) {
    return '预计瓦片数量：$count';
  }

  @override
  String mapCache_downloadedTiles(int completed, int total) {
    return '已下载 $completed / $total';
  }

  @override
  String get mapCache_downloadTilesButton => '下载瓦片';

  @override
  String get mapCache_clearCacheButton => '清除缓存';

  @override
  String mapCache_failedDownloads(int count) {
    return '下载失败：$count';
  }

  @override
  String mapCache_boundsLabel(
    String north,
    String south,
    String east,
    String west,
  ) {
    return '北 $north, 南 $south, 东 $east, 西 $west';
  }

  @override
  String get time_justNow => '刚才';

  @override
  String time_minutesAgo(int minutes) {
    return '$minutes分钟前';
  }

  @override
  String time_hoursAgo(int hours) {
    return '$hours小时前';
  }

  @override
  String time_daysAgo(int days) {
    return '$days 天前';
  }

  @override
  String get time_hour => '小时';

  @override
  String get time_hours => '小时';

  @override
  String get time_day => '今天';

  @override
  String get time_days => '天';

  @override
  String get time_week => '本周';

  @override
  String get time_weeks => '几周';

  @override
  String get time_month => '月份';

  @override
  String get time_months => '月份';

  @override
  String get time_minutes => '分钟';

  @override
  String get time_allTime => '所有时间';

  @override
  String get dialog_disconnect => '断开';

  @override
  String get dialog_disconnectConfirm => '您确定要断开与此设备的连接吗？';

  @override
  String get login_repeaterLogin => '重复登录';

  @override
  String get login_roomLogin => '房间登录';

  @override
  String get login_password => '密码';

  @override
  String get login_enterPassword => '请输入密码';

  @override
  String get login_savePassword => '保存密码';

  @override
  String get login_savePasswordSubtitle => '密码将安全地存储在这个设备上';

  @override
  String get login_repeaterDescription => '输入重复密码以访问设置和状态。';

  @override
  String get login_roomDescription => '输入房间密码以访问设置和状态。';

  @override
  String get login_routing => '路由';

  @override
  String get login_routingMode => '路由模式';

  @override
  String get login_autoUseSavedPath => '自动（使用已保存路径）';

  @override
  String get login_forceFloodMode => '强制洪水模式';

  @override
  String get login_managePaths => '管理路径';

  @override
  String get login_login => '登录';

  @override
  String login_attempt(int current, int max) {
    return '尝试 $current/$max';
  }

  @override
  String login_failed(String error) {
    return '登录失败：$error';
  }

  @override
  String get login_failedMessage => '登录失败。密码不正确或中继器不可达。';

  @override
  String get common_reload => '重新加载';

  @override
  String get common_clear => '清除';

  @override
  String path_currentPath(String path) {
    return '当前路径：$path';
  }

  @override
  String path_usingHopsPath(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hops',
      one: 'hop',
    );
    return '使用 $count $_temp0 路径';
  }

  @override
  String get path_enterCustomPath => '输入自定义路径';

  @override
  String get path_currentPathLabel => '当前路径';

  @override
  String get path_hexPrefixInstructions => '输入2个字符的十六进制前缀，每个前缀之间用逗号分隔。';

  @override
  String get path_hexPrefixExample => 'A1,F2,3C (每个节点使用其公钥的第一字节)';

  @override
  String get path_labelHexPrefixes => '十六进制前缀';

  @override
  String get path_helperMaxHops => '最大 64 步跳。每个前缀是 2 个十六进制字符（1 字节）';

  @override
  String get path_selectFromContacts => '或从联系人中选择：';

  @override
  String get path_noRepeatersFound => '未找到任何重复器或房间服务器。';

  @override
  String get path_customPathsRequire => '自定义路径需要中间跳转，这些跳转可以传递消息。';

  @override
  String path_invalidHexPrefixes(String prefixes) {
    return '无效的十六进制前缀：$prefixes';
  }

  @override
  String get path_tooLong => '路径太长。允许的最大跳跃次数为 64 次。';

  @override
  String get path_setPath => '设置路径';

  @override
  String get repeater_management => '重复器管理';

  @override
  String get room_management => '房间服务器管理';

  @override
  String get repeater_managementTools => '管理工具';

  @override
  String get repeater_status => '状态';

  @override
  String get repeater_statusSubtitle => '查看重复器状态、统计信息和邻居';

  @override
  String get repeater_telemetry => '遥测';

  @override
  String get repeater_telemetrySubtitle => '查看传感器和系统状态的Telemetry数据';

  @override
  String get repeater_cli => 'CLI';

  @override
  String get repeater_cliSubtitle => '发送命令到重复器';

  @override
  String get repeater_neighbours => '邻居';

  @override
  String get repeater_neighboursSubtitle => '查看零跳邻居。';

  @override
  String get repeater_settings => '设置';

  @override
  String get repeater_settingsSubtitle => '配置重复器参数';

  @override
  String get repeater_statusTitle => '重复器状态';

  @override
  String get repeater_routingMode => '路由模式';

  @override
  String get repeater_autoUseSavedPath => '自动（使用已保存路径）';

  @override
  String get repeater_forceFloodMode => '强制洪水模式';

  @override
  String get repeater_pathManagement => '路径管理';

  @override
  String get repeater_refresh => '刷新';

  @override
  String get repeater_statusRequestTimeout => '状态请求超时。';

  @override
  String repeater_errorLoadingStatus(String error) {
    return '错误加载状态：$error';
  }

  @override
  String get repeater_systemInformation => '系统信息';

  @override
  String get repeater_battery => '电池';

  @override
  String get repeater_clockAtLogin => '时间 (登录时)';

  @override
  String get repeater_uptime => '可用时间';

  @override
  String get repeater_queueLength => '排队长度';

  @override
  String get repeater_debugFlags => '调试标志';

  @override
  String get repeater_radioStatistics => '无线电统计';

  @override
  String get repeater_lastRssi => '上次RSSI';

  @override
  String get repeater_lastSnr => '最后 SNR';

  @override
  String get repeater_noiseFloor => '噪声地板';

  @override
  String get repeater_txAirtime => 'TX Airtime';

  @override
  String get repeater_rxAirtime => 'RX Airtime';

  @override
  String get repeater_packetStatistics => '数据包统计';

  @override
  String get repeater_sent => '已发送';

  @override
  String get repeater_received => '已收到';

  @override
  String get repeater_duplicates => '重复';

  @override
  String repeater_daysHoursMinsSecs(
    int days,
    int hours,
    int minutes,
    int seconds,
  ) {
    return '$days天 $hours小时 $minutes分 $seconds秒';
  }

  @override
  String repeater_packetTxTotal(int total, String flood, String direct) {
    return '总计：$total, 洪流：$flood, 直连：$direct';
  }

  @override
  String repeater_packetRxTotal(int total, String flood, String direct) {
    return '总计：$total, 洪流：$flood, 直连：$direct';
  }

  @override
  String repeater_duplicatesFloodDirect(String flood, String direct) {
    return '洪水：$flood, 直通：$direct';
  }

  @override
  String repeater_duplicatesTotal(int total) {
    return '总计：$total';
  }

  @override
  String get repeater_settingsTitle => '重复设置';

  @override
  String get repeater_basicSettings => '基本设置';

  @override
  String get repeater_repeaterName => '重复器名称';

  @override
  String get repeater_repeaterNameHelper => '显示此重复器的名称';

  @override
  String get repeater_adminPassword => '管理员密码';

  @override
  String get repeater_adminPasswordHelper => '完整访问密码';

  @override
  String get repeater_guestPassword => '访客密码';

  @override
  String get repeater_guestPasswordHelper => '只读访问密码';

  @override
  String get repeater_radioSettings => '射频设置';

  @override
  String get repeater_frequencyMhz => '频率 (MHz)';

  @override
  String get repeater_frequencyHelper => '300-2500 MHz';

  @override
  String get repeater_txPower => 'TX Power';

  @override
  String get repeater_txPowerHelper => '1-30 dBm';

  @override
  String get repeater_bandwidth => '带宽';

  @override
  String get repeater_spreadingFactor => '扩散因子';

  @override
  String get repeater_codingRate => '编码速率';

  @override
  String get repeater_locationSettings => '位置设置';

  @override
  String get repeater_latitude => '纬度';

  @override
  String get repeater_latitudeHelper => '十进度的数字（例如：37.7749）';

  @override
  String get repeater_longitude => '经度';

  @override
  String get repeater_longitudeHelper => '十进度的数字（例如：-122.4194）';

  @override
  String get repeater_features => '功能';

  @override
  String get repeater_packetForwarding => '数据包转发';

  @override
  String get repeater_packetForwardingSubtitle => '启用重复器以转发数据包';

  @override
  String get repeater_guestAccess => '访客访问';

  @override
  String get repeater_guestAccessSubtitle => '允许访客仅读访问';

  @override
  String get repeater_privacyMode => '隐私模式';

  @override
  String get repeater_privacyModeSubtitle => '隐藏在广告中的姓名/位置';

  @override
  String get repeater_advertisementSettings => '广告设置';

  @override
  String get repeater_localAdvertInterval => '本地广告间隔';

  @override
  String repeater_localAdvertIntervalMinutes(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String get repeater_floodAdvertInterval => '洪水广告间隔';

  @override
  String repeater_floodAdvertIntervalHours(int hours) {
    return '$hours 小时';
  }

  @override
  String get repeater_encryptedAdvertInterval => '加密广告间隔';

  @override
  String get repeater_dangerZone => '危险区域';

  @override
  String get repeater_rebootRepeater => '重启重复器';

  @override
  String get repeater_rebootRepeaterSubtitle => '重启重复器设备';

  @override
  String get repeater_rebootRepeaterConfirm => '您确定要重启这个中继器吗？';

  @override
  String get repeater_regenerateIdentityKey => '重新生成身份密钥';

  @override
  String get repeater_regenerateIdentityKeySubtitle => '生成新的公钥/私钥对';

  @override
  String get repeater_regenerateIdentityKeyConfirm => '这将生成一个重复器的新身份。继续吗？';

  @override
  String get repeater_eraseFileSystem => '删除文件系统';

  @override
  String get repeater_eraseFileSystemSubtitle => '格式化重复文件系统';

  @override
  String get repeater_eraseFileSystemConfirm => '警告：这将擦除重复器上的所有数据。 这无法撤销！';

  @override
  String get repeater_eraseSerialOnly => '通过串行控制台才能删除。';

  @override
  String repeater_commandSent(String command) {
    return '命令已发送：$command';
  }

  @override
  String repeater_errorSendingCommand(String error) {
    return '发送命令时出错：$error';
  }

  @override
  String get repeater_confirm => '确认';

  @override
  String get repeater_settingsSaved => '设置已保存成功';

  @override
  String repeater_errorSavingSettings(String error) {
    return '保存设置出错：$error';
  }

  @override
  String get repeater_refreshBasicSettings => '刷新基本设置';

  @override
  String get repeater_refreshRadioSettings => '刷新无线电设置';

  @override
  String get repeater_refreshTxPower => '刷新 TX 电量';

  @override
  String get repeater_refreshLocationSettings => '刷新位置设置';

  @override
  String get repeater_refreshPacketForwarding => '刷新包转发';

  @override
  String get repeater_refreshGuestAccess => '刷新访客访问';

  @override
  String get repeater_refreshPrivacyMode => '刷新隐私模式';

  @override
  String get repeater_refreshAdvertisementSettings => '刷新广告设置';

  @override
  String repeater_refreshed(String label) {
    return '$label 已刷新';
  }

  @override
  String repeater_errorRefreshing(String label) {
    return '刷新 $label 时出错';
  }

  @override
  String get repeater_cliTitle => '重复器命令行工具';

  @override
  String get repeater_debugNextCommand => '调试下一步命令';

  @override
  String get repeater_commandHelp => '帮助';

  @override
  String get repeater_clearHistory => '清除历史';

  @override
  String get repeater_noCommandsSent => '尚未发送任何命令';

  @override
  String get repeater_typeCommandOrUseQuick => '输入命令或使用快捷命令';

  @override
  String get repeater_enterCommandHint => '输入命令...';

  @override
  String get repeater_previousCommand => '上一个命令';

  @override
  String get repeater_nextCommand => '下一步命令';

  @override
  String get repeater_enterCommandFirst => '请输入一个命令';

  @override
  String get repeater_cliCommandFrameTitle => 'CLI 命令窗口';

  @override
  String repeater_cliCommandError(String error) {
    return '错误：$error';
  }

  @override
  String get repeater_cliQuickGetName => '获取姓名';

  @override
  String get repeater_cliQuickGetRadio => '获取收音机';

  @override
  String get repeater_cliQuickGetTx => '获取 TX';

  @override
  String get repeater_cliQuickNeighbors => '邻居';

  @override
  String get repeater_cliQuickVersion => '版本';

  @override
  String get repeater_cliQuickAdvertise => '发布';

  @override
  String get repeater_cliQuickClock => '时钟';

  @override
  String get repeater_cliHelpAdvert => '发送广告包';

  @override
  String get repeater_cliHelpReboot => '重启设备。(请注意，可能会出现“超时”现象，这是正常现象)';

  @override
  String get repeater_cliHelpClock => '显示每个设备的当前时间。';

  @override
  String get repeater_cliHelpPassword => '设置设备的新管理员密码。';

  @override
  String get repeater_cliHelpVersion => '显示设备版本和固件构建日期。';

  @override
  String get repeater_cliHelpClearStats => '重置各种统计数值为零。';

  @override
  String get repeater_cliHelpSetAf => '设置空闲时间因子。';

  @override
  String get repeater_cliHelpSetTx => '设置 LoRa 传输功率 (重置生效)';

  @override
  String get repeater_cliHelpSetRepeat => '启用或禁用此节点的重复器角色。';

  @override
  String get repeater_cliHelpSetAllowReadOnly =>
      '(房间服务器) 如果“开”了，则空密码登录将被允许，但不能向房间发布内容。（仅限读取）';

  @override
  String get repeater_cliHelpSetFloodMax => '设置最大换路包数量（如果 >= 最大，则不转发包）。';

  @override
  String get repeater_cliHelpSetIntThresh =>
      '设置干扰阈值（以 dB 为单位）。默认值为 14。将设置为 0 以禁用通道干扰检测。';

  @override
  String get repeater_cliHelpSetAgcResetInterval =>
      '设置间隔以重置自动增益控制器。将设置为 0 以禁用。';

  @override
  String get repeater_cliHelpSetMultiAcks => '启用或禁用“双 ACKs”功能。';

  @override
  String get repeater_cliHelpSetAdvertInterval =>
      '设置定时器间隔时间为分钟，以发送本地（零跳）广告包。将设置为0以禁用。';

  @override
  String get repeater_cliHelpSetFloodAdvertInterval =>
      '设置定时器间隔时间为小时，以发送洪水广告包。将设置为 0 以禁用。';

  @override
  String get repeater_cliHelpSetGuestPassword =>
      '设置/更新客人密码。（对于重复器，客人在登录时可以发送“获取统计”请求）';

  @override
  String get repeater_cliHelpSetName => '设置广告名称。';

  @override
  String get repeater_cliHelpSetLat => '设置广告地图纬度（十进制度）';

  @override
  String get repeater_cliHelpSetLon => '设置广告地图经度 (十进位)';

  @override
  String get repeater_cliHelpSetRadio => '设置全新的无线电参数，并保存到偏好设置。需要执行“重启”命令才能应用。';

  @override
  String get repeater_cliHelpSetRxDelay =>
      '设置（实验性）的基础（必须大于 1 才能生效）是用于对接收到的数据包应用轻微延迟，基于信号强度/得分。将设置为 0 以禁用。';

  @override
  String get repeater_cliHelpSetTxDelay =>
      '设置一个与时间-在空气中（time-on-air）的系数，用于洪水模式的数据包，并结合随机插槽系统，以延迟其转发。（以降低碰撞的可能性）';

  @override
  String get repeater_cliHelpSetDirectTxDelay =>
      '与txdelay相同，但用于为直接模式包的转发应用随机延迟。';

  @override
  String get repeater_cliHelpSetBridgeEnabled => '启用/禁用桥梁';

  @override
  String get repeater_cliHelpSetBridgeDelay => '设置在重新发送数据包之前延迟时间。';

  @override
  String get repeater_cliHelpSetBridgeSource => '选择桥梁是否会重传接收到的数据包或发送的数据包。';

  @override
  String get repeater_cliHelpSetBridgeBaud => '设置rs232桥接的串口链路波特率。';

  @override
  String get repeater_cliHelpSetBridgeSecret => '设置 espnow 桥的秘密。';

  @override
  String get repeater_cliHelpSetAdcMultiplier => '设置自定义因子以调整报告的电池电压（仅限部分板卡支持）。';

  @override
  String get repeater_cliHelpTempRadio =>
      '设置临时无线电参数，持续指定的分钟数，之后恢复为原始无线电参数。（不保存到偏好设置）。';

  @override
  String get repeater_cliHelpSetPerm =>
      '修改ACL。如果“权限”为零，则删除匹配的条目（通过pubkey前缀）。如果pubkey-hex的完整长度且当前不在ACL中，则添加新条目。通过匹配pubkey前缀更新条目。权限位因固件角色而异，但低2位为：0（Guest）、1（只读）、2（读写）、3（Admin）';

  @override
  String get repeater_cliHelpGetBridgeType => '获取桥接类型：无，RS232，ESPNow';

  @override
  String get repeater_cliHelpLogStart => '开始将数据包记录到文件系统。';

  @override
  String get repeater_cliHelpLogStop => '停止将数据包记录到文件系统。';

  @override
  String get repeater_cliHelpLogErase => '删除文件系统中的包日志。';

  @override
  String get repeater_cliHelpNeighbors =>
      '显示通过零跳广告收听的其他重复节点列表。 每行是 id-prefix-hex:时间戳:snr-times-4';

  @override
  String get repeater_cliHelpNeighborRemove =>
      '移除邻居列表中第一个匹配的条目（通过十六进制 pubkey 前缀）。';

  @override
  String get repeater_cliHelpRegion => '(仅显示区域) 列出所有已定义的区域和当前的防洪权限。';

  @override
  String get repeater_cliHelpRegionLoad =>
      '注意：这是一个特殊的多命令调用。 随后的每个命令都是一个区域名称（用空格缩进以指示父级层次结构，至少需要一个空格）。 以发送一个空行/命令结束。';

  @override
  String get repeater_cliHelpRegionGet =>
      '搜索具有给定名称前缀的区域（或“”用于全局范围）。回复为“-> region-name (parent-name) ‘F’”';

  @override
  String get repeater_cliHelpRegionPut => '添加或更新区域定义，使用指定名称。';

  @override
  String get repeater_cliHelpRegionRemove => '删除指定名称的区域定义。（必须没有子区域）';

  @override
  String get repeater_cliHelpRegionAllowf => '设置指定区域的“洪水”权限。（“”代表全局/遗留范围）';

  @override
  String get repeater_cliHelpRegionDenyf =>
      '移除指定区域的‘F’lood权限。 (注意：目前阶段不建议在此范围内使用，尤其是全局/旧版范围!!)';

  @override
  String get repeater_cliHelpRegionHome => '回复当前“主页”区域。 (注意尚未应用，保留用于未来)';

  @override
  String get repeater_cliHelpRegionHomeSet => '设置‘主页’区域。';

  @override
  String get repeater_cliHelpRegionSave => '保存区域列表/地图到存储。';

  @override
  String get repeater_cliHelpGps =>
      '显示GPS状态。当GPS关闭时，回复仅为“关闭”，如果已开启，则回复为“开启”、“状态”、“定位”和卫星数量。';

  @override
  String get repeater_cliHelpGpsOnOff => '切换 GPS 开启状态。';

  @override
  String get repeater_cliHelpGpsSync => '同步节点时间与 GPS 钟。';

  @override
  String get repeater_cliHelpGpsSetLoc => '设置节点位置至 GPS 坐标并保存偏好设置。';

  @override
  String get repeater_cliHelpGpsAdvert =>
      '提供节点广告配置位置：\n- none：不包含位置在广告中\n- share：分享 GPS 位置（来自 SensorManager）\n- prefs：在偏好设置中投放位置';

  @override
  String get repeater_cliHelpGpsAdvertSet => '设置广告位置配置。';

  @override
  String get repeater_commandsListTitle => '命令列表';

  @override
  String get repeater_commandsListNote => '注意：对于各种“设置...”命令，也存在“获取...”命令。';

  @override
  String get repeater_general => '通用';

  @override
  String get repeater_settingsCategory => '设置';

  @override
  String get repeater_bridge => '桥';

  @override
  String get repeater_logging => '记录';

  @override
  String get repeater_neighborsRepeaterOnly => '邻居（仅限重复器）';

  @override
  String get repeater_regionManagementRepeaterOnly => '区域管理（仅限重复器）';

  @override
  String get repeater_regionNote => '区域命令已推出，用于管理区域定义和权限。';

  @override
  String get repeater_gpsManagement => 'GPS管理';

  @override
  String get repeater_gpsNote => 'GPS 命令已引入用于管理与位置相关的主题。';

  @override
  String get telemetry_receivedData => '接收遥测数据';

  @override
  String get telemetry_requestTimeout => '遥测请求超时。';

  @override
  String telemetry_errorLoading(String error) {
    return '错误加载遥测数据：$error';
  }

  @override
  String get telemetry_noData => '没有可用的 telemetry 数据。';

  @override
  String telemetry_channelTitle(int channel) {
    return '频道 $channel';
  }

  @override
  String get telemetry_batteryLabel => '电池';

  @override
  String get telemetry_voltageLabel => '电压';

  @override
  String get telemetry_mcuTemperatureLabel => 'MCU 温度';

  @override
  String get telemetry_temperatureLabel => '温度';

  @override
  String get telemetry_currentLabel => '当前';

  @override
  String telemetry_batteryValue(int percent, String volts) {
    return '$percent% / ${volts}V';
  }

  @override
  String telemetry_voltageValue(String volts) {
    return '${volts}V';
  }

  @override
  String telemetry_currentValue(String amps) {
    return '${amps}A';
  }

  @override
  String telemetry_temperatureValue(String celsius, String fahrenheit) {
    return '$celsius°C / $fahrenheit°F';
  }

  @override
  String get neighbors_receivedData => '收到邻居数据';

  @override
  String get neighbors_requestTimedOut => '邻居请求超时处理。';

  @override
  String neighbors_errorLoading(String error) {
    return '加载邻居时出错：$error';
  }

  @override
  String get neighbors_repeatersNeighbours => '重复器邻居';

  @override
  String get neighbors_noData => '没有可用的邻居数据。';

  @override
  String neighbors_unknownContact(String pubkey) {
    return '未知$pubkey';
  }

  @override
  String neighbors_heardAgo(String time) {
    return '听到的时间：$time前';
  }

  @override
  String get channelPath_title => '数据包路径';

  @override
  String get channelPath_viewMap => '查看地图';

  @override
  String get channelPath_otherObservedPaths => '其他观察到的路径';

  @override
  String get channelPath_repeaterHops => '重复跳跃';

  @override
  String get channelPath_noHopDetails => '此包的详细信息未提供。';

  @override
  String get channelPath_messageDetails => '消息详情';

  @override
  String get channelPath_senderLabel => '发件人';

  @override
  String get channelPath_timeLabel => '时间';

  @override
  String get channelPath_repeatsLabel => '重复';

  @override
  String channelPath_pathLabel(int index) {
    return '路径 $index';
  }

  @override
  String get channelPath_observedLabel => '已观察';

  @override
  String channelPath_observedPathTitle(int index, String hops) {
    return '观察路径 $index • $hops';
  }

  @override
  String get channelPath_noLocationData => '没有位置数据';

  @override
  String channelPath_timeWithDate(int day, int month, String time) {
    return '$day/$month $time';
  }

  @override
  String channelPath_timeOnly(String time) {
    return '$time';
  }

  @override
  String get channelPath_unknownPath => '未知';

  @override
  String get channelPath_floodPath => '洪水';

  @override
  String get channelPath_directPath => '直接';

  @override
  String channelPath_observedZeroOf(int total) {
    return '0 of $total 跳跃';
  }

  @override
  String channelPath_observedSomeOf(int observed, int total) {
    return '已观察到 $observed 步中的 $total 步';
  }

  @override
  String get channelPath_mapTitle => '路径地图';

  @override
  String get channelPath_noRepeaterLocations => '此路径没有可用的重复器位置。';

  @override
  String channelPath_primaryPath(int index) {
    return '路径 $index (主)';
  }

  @override
  String get channelPath_pathLabelTitle => '路径';

  @override
  String get channelPath_observedPathHeader => '已观察路径';

  @override
  String channelPath_selectedPathLabel(String label, String prefixes) {
    return '$label • $prefixes';
  }

  @override
  String get channelPath_noHopDetailsAvailable => '此包的跳跃详情不可用。';

  @override
  String get channelPath_unknownRepeater => '未知重复器';

  @override
  String get community_title => '社区';

  @override
  String get community_create => '创建社区';

  @override
  String get community_createDesc => '创建新的社区并可通过二维码分享。';

  @override
  String get community_join => '加入';

  @override
  String get community_joinTitle => '加入社区';

  @override
  String community_joinConfirmation(String name) {
    return '您想加入社区 \"$name\" 吗？';
  }

  @override
  String get community_scanQr => '扫描社区二维码';

  @override
  String get community_scanInstructions => '将相机对准社区二维码';

  @override
  String get community_showQr => '显示二维码';

  @override
  String get community_publicChannel => '社区公开';

  @override
  String get community_hashtagChannel => '社区标签';

  @override
  String get community_name => '社区名称';

  @override
  String get community_enterName => '请输入社区名称';

  @override
  String community_created(String name) {
    return '社区“$name”已创建';
  }

  @override
  String community_joined(String name) {
    return '加入社区 \"$name\"';
  }

  @override
  String get community_qrTitle => '分享社区';

  @override
  String community_qrInstructions(String name) {
    return '扫描此二维码加入$name';
  }

  @override
  String get community_hashtagPrivacyHint => '社区标签频道仅社区成员可加入';

  @override
  String get community_invalidQrCode => '无效的社区二维码';

  @override
  String get community_alreadyMember => '已经是会员了';

  @override
  String community_alreadyMemberMessage(String name) {
    return '您已经是 \"$name\" 的会员。';
  }

  @override
  String get community_addPublicChannel => '添加社区公共频道';

  @override
  String get community_addPublicChannelHint => '自动添加该社区的公共频道';

  @override
  String get community_noCommunities => '尚未加入任何社区';

  @override
  String get community_scanOrCreate => '扫描二维码或创建社区开始';

  @override
  String get community_manageCommunities => '管理社群';

  @override
  String get community_delete => '退出社区';

  @override
  String community_deleteConfirm(String name) {
    return '退出 \"$name\"？';
  }

  @override
  String community_deleteChannelsWarning(int count) {
    return '这也将删除 $count 个频道及其消息。';
  }

  @override
  String community_deleted(String name) {
    return '已退出社区 \"$name\"';
  }

  @override
  String get community_regenerateSecret => '重新生成密钥';

  @override
  String community_regenerateSecretConfirm(String name) {
    return '重新生成“$name”的秘密密钥？所有成员将需要扫描新的二维码才能继续沟通。';
  }

  @override
  String get community_regenerate => '重新生成';

  @override
  String community_secretRegenerated(String name) {
    return '密码已重置为“$name”';
  }

  @override
  String get community_updateSecret => '更新密钥';

  @override
  String community_secretUpdated(String name) {
    return '密码已更新为“$name”';
  }

  @override
  String community_scanToUpdateSecret(String name) {
    return '扫描新的二维码更新\"$name\"的密码';
  }

  @override
  String get community_addHashtagChannel => '添加社区标签';

  @override
  String get community_addHashtagChannelDesc => '添加一个话题频道给此社区';

  @override
  String get community_selectCommunity => '选择社区';

  @override
  String get community_regularHashtag => '常规话题标签';

  @override
  String get community_regularHashtagDesc => '公共话题（任何人都可以加入）';

  @override
  String get community_communityHashtag => '社区标签';

  @override
  String get community_communityHashtagDesc => '仅限社区成员使用';

  @override
  String community_forCommunity(String name) {
    return '对于 $name';
  }

  @override
  String get listFilter_tooltip => '筛选和排序';

  @override
  String get listFilter_sortBy => '按类型排序';

  @override
  String get listFilter_latestMessages => '最新消息';

  @override
  String get listFilter_heardRecently => '最近听说';

  @override
  String get listFilter_az => 'A-Z';

  @override
  String get listFilter_filters => '筛选';

  @override
  String get listFilter_all => '全部';

  @override
  String get listFilter_users => '用户';

  @override
  String get listFilter_repeaters => '重复器';

  @override
  String get listFilter_roomServers => '房间服务器';

  @override
  String get listFilter_unreadOnly => '未读消息';

  @override
  String get listFilter_newGroup => '新组';

  @override
  String get pathTrace_you => '你';

  @override
  String get pathTrace_failed => '路径追踪失败。';

  @override
  String get pathTrace_notAvailable => '路径追踪不可用';

  @override
  String get pathTrace_refreshTooltip => '刷新路径追踪';

  @override
  String get contacts_pathTrace => '路径追踪';

  @override
  String get contacts_ping => 'ping';

  @override
  String get contacts_repeaterPathTrace => '路径追踪到中继器';

  @override
  String get contacts_repeaterPing => 'Ping 中继器';

  @override
  String get contacts_roomPathTrace => '路径追踪至房间服务器';

  @override
  String get contacts_roomPing => 'Ping 房间服务器';

  @override
  String get contacts_chatTraceRoute => '路径追踪';

  @override
  String contacts_pathTraceTo(String name) {
    return '追踪路由到 $name';
  }
}
