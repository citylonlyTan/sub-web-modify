<template>
  <div class="subconverter-page">
    <div class="subconverter-glow subconverter-glow--one"></div>
    <div class="subconverter-glow subconverter-glow--two"></div>
    <el-row class="subconverter-layout" style="margin-top: 10px">
      <el-col>
        <el-card class="subconverter-card">
          <div slot="header" class="subconverter-hero">
            <div class="subconverter-hero__copy">
              <span class="subconverter-hero__eyebrow">SUB WEB / NEXT</span>
              <div class="subconverter-hero__topline">
                <h1 class="subconverter-hero__title">订阅转换</h1>
                <div class="subconverter-hero__stats">
                  <div class="subconverter-stat subconverter-stat--backend">
                    <span>后端版本</span>
                    <strong>{{ backendVersion || "等待检测" }}</strong>
                  </div>
                </div>
              </div>
              <p class="subconverter-hero__desc">
                在线订阅转换场景，适配 Clash、Surge、Sing-Box 等常见使用环境。
              </p>
            </div>
          </div>
          <el-container class="subconverter-container">
            <el-form class="subconverter-form" :model="form" label-width="92px" label-position="left" style="width: 100%">
              <el-form-item label="订阅链接:">
                <el-input v-model="form.sourceSubUrl" type="textarea" rows="3"
                  placeholder="支持各种订阅链接或单节点链接，多个链接每行一个或用 | 分隔" />
              </el-form-item>
              <el-form-item label="生成类型:">
                <el-select v-model="form.clientType" style="width: 100%">
                  <el-option v-for="(v, k) in options.clientTypes" :key="k" :label="k" :value="v"></el-option>
                </el-select>
              </el-form-item>
              <el-form-item label="后端地址:">
                <el-select v-model="form.customBackend" allow-create filterable @change="selectChanged"
                  placeholder="可输入自己的后端" style="width: 100%">
                  <el-option v-for="(v, k) in options.customBackend" :key="k" :label="k" :value="v"></el-option>
                </el-select>
              </el-form-item>
              <el-form-item label="短链选择:">
                <el-select v-model="form.shortType" allow-create filterable placeholder="可输入其他可用短链API"
                  style="width: 100%">
                  <el-option v-for="(v, k) in options.shortTypes" :key="k" :label="k" :value="v"></el-option>
                </el-select>
              </el-form-item>

              <el-form-item label="远程配置:">
                <el-select v-model="form.remoteConfig" allow-create filterable placeholder="请选择" style="width: 100%">
                  <el-option-group v-for="group in options.remoteConfig" :key="group.label" :label="group.label">
                    <el-option v-for="item in group.options" :key="item.value" :label="item.label"
                      :value="item.value"></el-option>
                  </el-option-group>
                </el-select>
              </el-form-item>
              <el-form-item class="subconverter-advanced__wrap" label-width="0px">
                <el-collapse class="subconverter-advanced">
                  <el-collapse-item>
                    <template slot="title">
                      <el-form-item label="高级功能:" style="width: 100%;">
                        <el-button type="limr" style="width: 100%;" icon="el-icon-more-outline">点击显示/隐藏
                        </el-button>
                      </el-form-item>
                    </template>
                    <el-form-item label="包含节点:">
                      <el-input v-model="form.includeRemarks" placeholder="要保留的节点，支持正则" />
                    </el-form-item>
                    <el-form-item label="排除节点:">
                      <el-input v-model="form.excludeRemarks" placeholder="要排除的节点，支持正则" />
                    </el-form-item>
                    <el-form-item label="节点命名:">
                      <el-input v-model="form.rename" placeholder="举例：`a@b``1@2`，|符可用\转义" />
                    </el-form-item>
                    <el-form-item label="远程设备:">
                      <el-input v-model="form.devid" placeholder="用于设置QuantumultX的远程设备ID" />
                    </el-form-item>
                    <el-form-item label="更新间隔:">
                      <el-input v-model="form.interval" placeholder="返用于设置托管配置更新间隔，单位为天" />
                    </el-form-item>
                    <el-form-item label="订阅命名:">
                      <el-input v-model="form.filename" placeholder="返回的订阅文件名，可以在支持文件名的客户端中显示出来" />
                    </el-form-item>
                    <el-form-item class="eldiy" label-width="0px">
                      <el-row type="flex">
                        <el-col>
                          <el-checkbox v-model="form.nodeList" label="仅输出节点信息" border></el-checkbox>
                        </el-col>
                        <el-popover placement="bottom" v-model="form.extraset">
                          <el-row :gutter="10">
                            <el-col :span="12">
                              <el-checkbox v-model="form.emoji" label="Emoji"></el-checkbox>
                            </el-col>
                            <el-col :span="12">
                              <el-checkbox v-model="form.insert" label="插入默认节点"></el-checkbox>
                            </el-col>
                          </el-row>
                          <el-row :gutter="10">
                            <el-col :span="12">
                              <el-checkbox v-model="form.udp" label="启用 UDP"></el-checkbox>
                            </el-col>
                            <el-col :span="12">
                              <el-checkbox v-model="form.xudp" label="启用 XUDP"></el-checkbox>
                            </el-col>
                          </el-row>
                          <el-row :gutter="10">
                            <el-col :span="12">
                              <el-checkbox v-model="form.tfo" label="启用 TFO"></el-checkbox>
                            </el-col>
                            <el-col :span="12">
                              <el-checkbox v-model="form.sort" label="基础节点排序"></el-checkbox>
                            </el-col>
                          </el-row>
                          <el-row :gutter="10">
                            <el-col :span="12">
                              <el-checkbox v-model="form.tpl.clash.doh" label="Clash.DoH"></el-checkbox>
                            </el-col>
                            <el-col :span="12">
                              <el-checkbox v-model="form.appendType" label="插入节点类型"></el-checkbox>
                            </el-col>
                          </el-row>
                          <el-row :gutter="10">
                            <el-col :span="12">
                              <el-checkbox v-model="form.tpl.surge.doh" label="Surge.DoH"></el-checkbox>
                            </el-col>
                            <el-col :span="12">
                              <el-checkbox v-model="form.tls13" label="开启TLS_1.3"></el-checkbox>
                            </el-col>
                          </el-row>
                          <el-row :gutter="10">
                            <el-col :span="12">
                              <el-checkbox v-model="form.expand" label="展开规则全文"></el-checkbox>
                            </el-col>
                            <el-col :span="12">
                              <el-checkbox v-model="form.new_name" label="Clash新字段名"></el-checkbox>
                            </el-col>
                          </el-row>
                          <el-row :gutter="10">
                            <el-col :span="12">
                              <el-checkbox v-model="form.scv" label="跳过证书验证"></el-checkbox>
                            </el-col>
                            <el-col :span="12">
                              <el-checkbox v-model="form.fdn" label="过滤不支持节点"></el-checkbox>
                            </el-col>
                          </el-row>
                          <el-row :gutter="10">
                            <el-col :span="12">
                              <div style="margin-left: 35%">
                                <el-checkbox v-model="form.tpl.singbox.ipv6" label="Sing-Box支持IPV6"></el-checkbox>
                              </div>
                            </el-col>
                          </el-row>
                          <el-button slot="reference">更多选项</el-button>
                        </el-popover>
                      </el-row>
                    </el-form-item>
                  </el-collapse-item>
                </el-collapse>
              </el-form-item>
              <div style="margin-top: 30px"></div>
              <el-form-item class="subconverter-output" label="定制订阅:">
                <el-input class="copy-content" disabled v-model="customSubUrl">
                  <el-button slot="append" v-clipboard:copy="customSubUrl" v-clipboard:success="onCopy" ref="copy-btn"
                    icon="el-icon-document-copy">复制
                  </el-button>
                </el-input>
              </el-form-item>
              <el-form-item class="subconverter-output" label="订阅短链:">
                <el-input class="copy-content" v-model="customShortSubUrl" placeholder="输入自定义短链接后缀，点击生成短链接可反复生成">
                  <el-button slot="append" v-clipboard:copy="customShortSubUrl" v-clipboard:success="onCopy"
                    ref="copy-btn" icon="el-icon-document-copy">复制
                  </el-button>
                </el-input>
              </el-form-item>
              <el-form-item class="subconverter-action-row" label-width="0px" style="margin-top: 40px; text-align: center">
                <el-button class="subconverter-main-btn" style="width: 120px" type="danger" @click="makeUrl"
                  :disabled="form.sourceSubUrl.length === 0 || btnBoolean">生成订阅链接
                </el-button>
                <el-button class="subconverter-main-btn subconverter-main-btn--alt" style="width: 120px" type="danger" @click="makeShortUrl" :loading="loading1"
                  :disabled="customSubUrl.length === 0">生成短链接
                </el-button>
                <el-button class="subconverter-main-btn subconverter-main-btn--parse" style="width: 120px" type="primary"
                  icon="el-icon-copy-document" @click="dialogLoadConfigVisible = true" :loading="loading3">从URL解析
                </el-button>
              </el-form-item>
            </el-form>
          </el-container>
        </el-card>
      </el-col>
    </el-row>
    <div class="subconverter-social-dock" aria-label="页面底部快捷入口">
      <button class="subconverter-social-btn" type="button" @click="goToProject" aria-label="GitHub" title="GitHub">
        <svg viewBox="0 0 24 24" fill="none" class="subconverter-social-btn__icon" aria-hidden="true">
          <path d="M9.2 19.1v-3.2c-3.2.7-3.9-1.4-3.9-1.4-.5-1.2-1.2-1.5-1.2-1.5-1-.7.1-.7.1-.7 1.1.1 1.7 1.1 1.7 1.1 1 .1 1.6.8 1.9 1.4.9.4 1.8.3 2.5.1.1-.7.4-1.2.7-1.5-2.6-.3-5.3-1.3-5.3-5.7 0-1.3.5-2.3 1.1-3.1-.1-.3-.5-1.5.1-3 0 0 .9-.3 3.2 1.2a10.7 10.7 0 0 1 5.8 0c2.2-1.5 3.2-1.2 3.2-1.2.6 1.5.2 2.7.1 3 .7.8 1.1 1.8 1.1 3.1 0 4.4-2.7 5.3-5.3 5.7.4.4.8 1 .8 2.1v3.6" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>
          <path d="M8.9 18.8c-3.5 1.1-6-1.4-6-1.4" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>
        </svg>
      </button>
      <button class="subconverter-social-btn" type="button" @click="gotoTgChannel" aria-label="Telegram" title="Telegram">
        <svg viewBox="0 0 24 24" fill="none" class="subconverter-social-btn__icon" aria-hidden="true">
          <path d="M21 4.5 3.8 11.2c-.8.3-.8 1.4 0 1.6l4.1 1.4 1.6 5c.2.8 1.2 1 1.7.4l2.4-2.7 4.2 3.1c.7.5 1.7.1 1.9-.8L22 5.8c.2-.9-.5-1.7-1.4-1.3Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/>
          <path d="m8 14 9.1-6.7M9.5 18.5 11 14l7.6-6.7" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </button>
      <button class="subconverter-social-btn" type="button" @click="gotoYouTuBe" aria-label="YouTube" title="YouTube">
        <svg viewBox="0 0 24 24" fill="none" class="subconverter-social-btn__icon" aria-hidden="true">
          <rect x="3.5" y="6" width="17" height="12" rx="4.2" stroke="currentColor" stroke-width="1.7"/>
          <path d="m10 9.4 5.5 2.7-5.5 2.7V9.4Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/>
        </svg>
      </button>
      <button class="subconverter-social-btn subconverter-social-btn--theme" type="button" @click="change" aria-label="切换主题">
        <i id="rijian" class="el-icon-sunny subconverter-theme-toggle-icon"></i>
        <i id="yejian" class="el-icon-moon subconverter-theme-toggle-icon"></i>
      </button>
    </div>
    <el-dialog title="请选择需要观看的视频教程" :visible.sync="centerDialogVisible" custom-class="subconverter-dialog" :show-close="true" width="420px" top="22vh"
      center>
      <div label-width="0px" style="text-align: center">
        <el-button style="width: 200px;" type="primary" icon="el-icon-video-play"
          @click="gotoBasicVideo(); centerDialogVisible = false">基础视频教程
        </el-button>
      </div>
      <div label-width="0px" style="text-align: center;margin: 3vh 0 2vh">
        <el-button style="width: 200px;" type="danger" icon="el-icon-video-play"
          @click="gotoAdvancedVideo(); centerDialogVisible = false">进阶视频教程
        </el-button>
      </div>
    </el-dialog>
    <el-dialog :visible.sync="dialogUploadConfigVisible" custom-class="subconverter-dialog" :show-close="true" :close-on-click-modal="false"
      :close-on-press-escape="false" width="80%">
      <el-tabs v-model="activeName" type="card">
        <el-tab-pane label="远程配置上传" name="first">
          <el-link type="danger" :href="sampleConfig" style="margin-bottom: 15px" target="_blank" icon="el-icon-info">
            参考案例
          </el-link>
          <el-form label-position="left">
            <el-form-item prop="uploadConfig">
              <el-input v-model="uploadConfig" type="textarea" :autosize="{ minRows: 15, maxRows: 15 }"
                maxlength="50000" show-word-limit></el-input>
            </el-form-item>
          </el-form>
          <div style="float: right">
            <el-button type="primary" @click="uploadConfig = ''; dialogUploadConfigVisible = false">取 消</el-button>
            <el-button type="primary" @click="confirmUploadConfig" :disabled="uploadConfig.length === 0">确 定
            </el-button>
          </div>
        </el-tab-pane>
        <el-tab-pane label="JS排序节点" name="second">
          <el-link type="success" :href="scriptConfig" style="margin-bottom: 15px" target="_blank" icon="el-icon-info">
            参考案例
          </el-link>
          <el-form label-position="left">
            <el-form-item prop="uploadScript">
              <el-input v-model="uploadScript" placeholder="本功能暂停使用，如有兴趣，自行去我的GitHub参考sub-web-api项目部署！" type="textarea"
                :autosize="{ minRows: 15, maxRows: 15 }" maxlength="50000" show-word-limit></el-input>
            </el-form-item>
          </el-form>
          <div style="float: right">
            <el-button type="primary" @click="uploadScript = ''; dialogUploadConfigVisible = false">取 消</el-button>
            <el-button type="primary" @click="confirmUploadScript" :disabled="uploadScript.length === 0">确 定
            </el-button>
          </div>
        </el-tab-pane>
        <el-tab-pane label="JS筛选节点" name="third">
          <el-link type="warning" :href="filterConfig" style="margin-bottom: 15px" target="_blank" icon="el-icon-info">
            参考案例
          </el-link>
          <el-form label-position="left">
            <el-form-item prop="uploadFilter">
              <el-input v-model="uploadFilter" placeholder="本功能暂停使用，如有兴趣，自行去我的GitHub参考sub-web-api项目部署！" type="textarea"
                :autosize="{ minRows: 15, maxRows: 15 }" maxlength="50000" show-word-limit></el-input>
            </el-form-item>
          </el-form>
          <div style="float: right">
            <el-button type="primary" @click="uploadFilter = ''; dialogUploadConfigVisible = false">取 消</el-button>
            <el-button type="primary" @click="confirmUploadScript" :disabled="uploadFilter.length === 0">确 定
            </el-button>
          </div>
        </el-tab-pane>
      </el-tabs>
    </el-dialog>
    <el-dialog :visible.sync="dialogLoadConfigVisible" custom-class="subconverter-dialog" :show-close="true" :close-on-click-modal="false"
      :close-on-press-escape="false" width="80%">
      <div slot="title">
        可以从生成的长/短链接中解析信息,填入页面中去
      </div>
      <el-form label-position="left">
        <el-form-item prop="uploadConfig">
          <el-input v-model="loadConfig" type="textarea" :autosize="{ minRows: 15, maxRows: 15 }" maxlength="5000"
            show-word-limit></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="loadConfig = ''; dialogLoadConfigVisible = false">取 消</el-button>
        <el-button type="primary" @click="confirmLoadConfig" :disabled="loadConfig.length === 0">确 定
        </el-button>
      </div>
    </el-dialog>
  </div>
</template>
<script>
const project = process.env.VUE_APP_PROJECT
const configScriptBackend = process.env.VUE_APP_CONFIG_UPLOAD_BACKEND + '/api.php'
const remoteConfigSample = process.env.VUE_APP_SUBCONVERTER_REMOTE_CONFIG
const scriptConfigSample = process.env.VUE_APP_SCRIPT_CONFIG
const filterConfigSample = process.env.VUE_APP_FILTER_CONFIG
const defaultBackend = process.env.VUE_APP_SUBCONVERTER_DEFAULT_BACKEND
const shortUrlBackend = process.env.VUE_APP_MYURLS_DEFAULT_BACKEND + '/short'
const configUploadBackend = process.env.VUE_APP_CONFIG_UPLOAD_BACKEND + '/sub.php'
const basicVideo = process.env.VUE_APP_BASIC_VIDEO
const advancedVideo = process.env.VUE_APP_ADVANCED_VIDEO
const tgBotLink = process.env.VUE_APP_BOT_LINK
const yglink = process.env.VUE_APP_YOUTUBE_LINK
const bzlink = process.env.VUE_APP_BILIBILI_LINK
export default {
  data() {
    return {
      backendVersion: "",
      centerDialogVisible: false,
      activeName: 'first',
      // 是否为 PC 端
      isPC: true,
      btnBoolean: false,
      options: {
        clientTypes: {
          Clash: "clash",
          "Surge4/5": "surge&ver=4",
          "Sing-Box": "singbox",
          V2Ray: "v2ray",
          Trojan: "trojan",
          ShadowsocksR: "ssr",
          "混合订阅（mixed）": "mixed",
          Surfboard: "surfboard",
          Quantumult: "quan",
          "Quantumult X": "quanx",
          Loon: "loon",
          Mellow: "mellow",
          Surge3: "surge&ver=3",
          Surge2: "surge&ver=2",
          ClashR: "clashr",
          "Shadowsocks(SIP002)": "ss",
          "Shadowsocks Android(SIP008)": "sssub",
          ShadowsocksD: "ssd",
          "自动判断客户端": "auto",
        },
        shortTypes: {
          "v1.mk": "https://v1.mk/short",
          "d1.mk": "https://d1.mk/short",
          "dlj.tf": "https://dlj.tf/short",
        },
        customBackend: {
          "我的私有 NAS 后端": "https://subcon.833933.xyz:65525",
          "CM提供-负载均衡后端": "https://subapi.cmliussss.net",
          "CM提供-应急备用后端": "https://subapi.fxxk.dedyn.io",
          "肥羊提供-增强型后端": "https://url.v1.mk",
          "肥羊提供-备用后端": "https://api.v1.mk",
        },
        backendOptions: [
          { value: "https://subcon.833933.xyz:65525" },
          { value: "https://subapi.cmliussss.net" },
          { value: "https://subapi.fxxk.dedyn.io" },
          { value: "https://url.v1.mk" },
          { value: "https://api.v1.mk" },
        ],
        remoteConfig: [
          {
            label: "CM规则",
            options: [
              {
                label: "CM_Online 默认版 识别港美地区(与Github同步)",
                value: "https://raw.githubusercontent.com/cmliu/ACL4SSR/main/Clash/config/ACL4SSR_Online.ini"
              },
              {
                label: "CM_Online_MultiCountry 识别港美地区 负载均衡(与Github同步)",
                value: "https://raw.githubusercontent.com/cmliu/ACL4SSR/main/Clash/config/ACL4SSR_Online_MultiCountry.ini"
              },
              {
                label: "CM_Online_MultiCountry_CF 识别港美地区、CloudFlareCDN 负载均衡 Worker节点专用(与Github同步)",
                value: "https://raw.githubusercontent.com/cmliu/ACL4SSR/main/Clash/config/ACL4SSR_Online_MultiCountry_CF.ini"
              },
              {
                label: "CM_Online_Full 识别多地区分组(与Github同步)",
                value: "https://raw.githubusercontent.com/cmliu/ACL4SSR/main/Clash/config/ACL4SSR_Online_Full.ini"
              },
              {
                label: "CM_Online_Full_CF 识别多地区、CloudFlareCDN 分组 Worker节点专用(与Github同步)",
                value: "https://raw.githubusercontent.com/cmliu/ACL4SSR/main/Clash/config/ACL4SSR_Online_Full_CF.ini"
              },
              {
                label: "CM_Online_Full_MultiMode 识别多地区 负载均衡(与Github同步)",
                value: "https://raw.githubusercontent.com/cmliu/ACL4SSR/main/Clash/config/ACL4SSR_Online_Full_MultiMode.ini"
              },
              {
                label: "CM_Online_Full_MultiMode_CF 识别多地区、CloudFlareCDN 负载均衡 Worker节点专用(与Github同步)",
                value: "https://raw.githubusercontent.com/cmliu/ACL4SSR/main/Clash/config/ACL4SSR_Online_Full_MultiMode_CF.ini"
              }
            ]
          },
          {
            label: "通用",
            options: [
              {
                label: "默认",
                value: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Full_NoAuto.ini"
              },
              {
                label: "默认（自动测速）",
                value: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Full_AdblockPlus.ini"
              },
              {
                label: "默认（索尼电视专用）",
                value: "https://raw.githubusercontent.com/youshandefeiyang/webcdn/main/SONY.ini"
              },
              {
                label: "默认（附带用于 Clash 的 AdGuard DNS）",
                value: "https://gist.githubusercontent.com/tindy2013/1fa08640a9088ac8652dbd40c5d2715b/raw/default_with_clash_adg.yml"
              },
              {
                label: "ACL_全分组 Dream修改版",
                value: "https://raw.githubusercontent.com/WC-Dream/ACL4SSR/WD/Clash/config/ACL4SSR_Online_Full_Dream.ini"
              },
              {
                label: "ACL_精简分组 Dream修改版",
                value: "https://raw.githubusercontent.com/WC-Dream/ACL4SSR/WD/Clash/config/ACL4SSR_Mini_Dream.ini"
              },
              {
                label: "emby-TikTok-流媒体分组-去广告加强版",
                value: "https://raw.githubusercontent.com/justdoiting/ClashRule/main/GeneralClashRule.ini"
              },
              {
                label: "流媒体通用分组",
                value: "https://raw.githubusercontent.com/cutethotw/ClashRule/main/GeneralClashRule.ini"
              }
            ]
          },
          {
            label: "ACL规则",
            options: [
              {
                label: "ACL_默认版",
                value: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online.ini"
              },
              {
                label: "ACL_无测速版",
                value: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_NoAuto.ini"
              },
              {
                label: "ACL_去广告版",
                value: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_AdblockPlus.ini"
              },
              {
                label: "ACL_多国家版",
                value: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_MultiCountry.ini"
              },
              {
                label: "ACL_无Reject版",
                value: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_NoReject.ini"
              },
              {
                label: "ACL_无测速精简版",
                value: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Mini_NoAuto.ini"
              },
              {
                label: "ACL_全分组版",
                value: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Full.ini"
              },
              {
                label: "ACL_全分组谷歌版",
                value: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Full_Google.ini"
              },
              {
                label: "ACL_全分组多模式版",
                value: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Full_MultiMode.ini"
              },
              {
                label: "ACL_全分组奈飞版",
                value: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Full_Netflix.ini"
              },
              {
                label: "ACL_精简版",
                value: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Mini.ini"
              },
              {
                label: "ACL_去广告精简版",
                value: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Mini_AdblockPlus.ini"
              },
              {
                label: "ACL_Fallback精简版",
                value: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Mini_Fallback.ini"
              },
              {
                label: "ACL_多国家精简版",
                value: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Mini_MultiCountry.ini"
              },
              {
                label: "ACL_多模式精简版",
                value: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Mini_MultiMode.ini"
              }
            ]
          },
          {
            label: "全网搜集规则",
            options: [
              {
                label: "常规规则",
                value: "https://raw.githubusercontent.com/flyhigherpi/merlinclash_clash_related/master/Rule_config/ZHANG.ini"
              },
              {
                label: "酷酷自用",
                value: "https://raw.githubusercontent.com/xiaoshenxian233/cool/rule/complex.ini"
              },
              {
                label: "PharosPro无测速",
                value:
                  "https://subweb.s3.fr-par.scw.cloud/RemoteConfig/special/phaors.ini"
              },
              {
                label: "分区域故障转移",
                value: "https://raw.githubusercontent.com/flyhigherpi/merlinclash_clash_related/master/Rule_config/ZHANG_Area_Fallback.ini"
              },
              {
                label: "分区域自动测速",
                value: "https://raw.githubusercontent.com/flyhigherpi/merlinclash_clash_related/master/Rule_config/ZHANG_Area_Urltest.ini"
              },
              {
                label: "分区域无自动测速",
                value: "https://raw.githubusercontent.com/flyhigherpi/merlinclash_clash_related/master/Rule_config/ZHANG_Area_NoAuto.ini"
              },
              {
                label: "OoHHHHHHH",
                value: "https://raw.githubusercontent.com/OoHHHHHHH/ini/master/config.ini"
              },
              {
                label: "CFW-TAP",
                value: "https://raw.githubusercontent.com/OoHHHHHHH/ini/master/cfw-tap.ini"
              },
              {
                label: "lhl77全分组（定期更新）",
                value: "https://raw.githubusercontent.com/lhl77/sub-ini/main/tsutsu-full.ini"
              },
              {
                label: "lhl77简易版（定期更新）",
                value: "https://raw.githubusercontent.com/lhl77/sub-ini/main/tsutsu-mini-gfw.ini"
              },
              {
                label: "ConnersHua 神机规则 Outbound",
                value: "https://gist.githubusercontent.com/tindy2013/1fa08640a9088ac8652dbd40c5d2715b/raw/connershua_new.ini"
              },
              {
                label: "ConnersHua 神机规则 Inbound 回国专用",
                value: "https://gist.githubusercontent.com/tindy2013/1fa08640a9088ac8652dbd40c5d2715b/raw/connershua_backtocn.ini"
              },
              {
                label: "lhie1 洞主规则（使用 Clash 分组规则）",
                value: "https://gist.githubusercontent.com/tindy2013/1fa08640a9088ac8652dbd40c5d2715b/raw/lhie1_clash.ini"
              },
              {
                label: "lhie1 洞主规则完整版",
                value: "https://gist.githubusercontent.com/tindy2013/1fa08640a9088ac8652dbd40c5d2715b/raw/lhie1_dler.ini"
              },
              {
                label: "eHpo1 规则",
                value: "https://gist.githubusercontent.com/tindy2013/1fa08640a9088ac8652dbd40c5d2715b/raw/ehpo1_main.ini"
              },
              {
                label: "多策略组默认白名单模式",
                value: "https://raw.nameless13.com/api/public/dl/ROzQqi2S/white.ini"
              },
              {
                label: "多策略组可以有效减少审计触发",
                value: "https://raw.nameless13.com/api/public/dl/ptLeiO3S/mayinggfw.ini"
              },
              {
                label: "精简策略默认白名单",
                value: "https://raw.nameless13.com/api/public/dl/FWSh3dXz/easy3.ini"
              },
              {
                label: "多策略增加SMTP策略",
                value: "https://raw.nameless13.com/api/public/dl/L_-vxO7I/youtube.ini"
              },
              {
                label: "无策略入门推荐",
                value: "https://raw.nameless13.com/api/public/dl/zKF9vFbb/easy.ini"
              },
              {
                label: "无策略入门推荐国家分组",
                value: "https://raw.nameless13.com/api/public/dl/E69bzCaE/easy2.ini"
              },
              {
                label: "无策略仅IPIP CN + Final",
                value: "https://raw.nameless13.com/api/public/dl/XHr0miMg/ipip.ini"
              },
              {
                label: "无策略魅影vip分组",
                value: "https://raw.nameless13.com/api/public/dl/BBnfb5lD/MAYINGVIP.ini"
              },
              {
                label: "品云专属配置（仅香港区域分组）",
                value: "https://raw.githubusercontent.com/Mazeorz/airports/master/Clash/Examine.ini"
              },
              {
                label: "品云专属配置（全地域分组）",
                value: "https://raw.githubusercontent.com/Mazeorz/airports/master/Clash/Examine_Full.ini"
              },
              {
                label: "nzw9314 规则",
                value: "https://gist.githubusercontent.com/tindy2013/1fa08640a9088ac8652dbd40c5d2715b/raw/nzw9314_custom.ini"
              },
              {
                label: "maicoo-l 规则",
                value: "https://gist.githubusercontent.com/tindy2013/1fa08640a9088ac8652dbd40c5d2715b/raw/maicoo-l_custom.ini"
              },
              {
                label: "DlerCloud Platinum 李哥定制规则",
                value: "https://gist.githubusercontent.com/tindy2013/1fa08640a9088ac8652dbd40c5d2715b/raw/dlercloud_lige_platinum.ini"
              },
              {
                label: "DlerCloud Gold 李哥定制规则",
                value: "https://gist.githubusercontent.com/tindy2013/1fa08640a9088ac8652dbd40c5d2715b/raw/dlercloud_lige_gold.ini"
              },
              {
                label: "DlerCloud Silver 李哥定制规则",
                value: "https://gist.githubusercontent.com/tindy2013/1fa08640a9088ac8652dbd40c5d2715b/raw/dlercloud_lige_silver.ini"
              },
              {
                label: "ProxyStorage自用",
                value: "https://unpkg.com/proxy-script/config/Clash/clash.ini"
              },
              {
                label: "ShellClash修改版规则 (by UlinoyaPed)",
                value: "https://github.com/UlinoyaPed/ShellClash/raw/master/rules/ShellClash.ini"
              }
            ]
          },
          {
            label: "各大机场规则",
            options: [
              {
                label: "EXFLUX",
                value:
                  "https://gist.github.com/jklolixxs/16964c46bad1821c70fa97109fd6faa2/raw/EXFLUX.ini"
              },
              {
                label: "NaNoport",
                value:
                  "https://gist.github.com/jklolixxs/32d4e9a1a5d18a92beccf3be434f7966/raw/NaNoport.ini"
              },
              {
                label: "CordCloud",
                value:
                  "https://gist.github.com/jklolixxs/dfbe0cf71ffc547557395c772836d9a8/raw/CordCloud.ini"
              },
              {
                label: "BigAirport",
                value:
                  "https://gist.github.com/jklolixxs/e2b0105c8be6023f3941816509a4c453/raw/BigAirport.ini"
              },
              {
                label: "跑路云",
                value:
                  "https://gist.github.com/jklolixxs/9f6989137a2cfcc138c6da4bd4e4cbfc/raw/PaoLuCloud.ini"
              },
              {
                label: "WaveCloud",
                value:
                  "https://gist.github.com/jklolixxs/fccb74b6c0018b3ad7b9ed6d327035b3/raw/WaveCloud.ini"
              },
              {
                label: "几鸡",
                value:
                  "https://gist.github.com/jklolixxs/bfd5061dceeef85e84401482f5c92e42/raw/JiJi.ini"
              },
              {
                label: "四季加速",
                value:
                  "https://gist.github.com/jklolixxs/6ff6e7658033e9b535e24ade072cf374/raw/SJ.ini"
              },
              {
                label: "ImmTelecom",
                value:
                  "https://gist.github.com/jklolixxs/24f4f58bb646ee2c625803eb916fe36d/raw/ImmTelecom.ini"
              },
              {
                label: "AmyTelecom",
                value:
                  "https://gist.github.com/jklolixxs/b53d315cd1cede23af83322c26ce34ec/raw/AmyTelecom.ini"
              },
              {
                label: "LinkCube",
                value:
                  "https://subweb.s3.fr-par.scw.cloud/RemoteConfig/customized/convenience.ini"
              },
              {
                label: "Miaona",
                value:
                  "https://gist.github.com/jklolixxs/ff8ddbf2526cafa568d064006a7008e7/raw/Miaona.ini"
              },
              {
                label: "Foo&Friends",
                value:
                  "https://gist.github.com/jklolixxs/df8fda1aa225db44e70c8ac0978a3da4/raw/Foo&Friends.ini"
              },
              {
                label: "ABCloud",
                value:
                  "https://gist.github.com/jklolixxs/b1f91606165b1df82e5481b08fd02e00/raw/ABCloud.ini"
              },
              {
                label: "咸鱼",
                value: "https://raw.githubusercontent.com/SleepyHeeead/subconverter-config/master/remote-config/customized/xianyu.ini"
              },
              {
                label: "便利店",
                value: "https://subweb.oss-cn-hongkong.aliyuncs.com/RemoteConfig/customized/convenience.ini"
              },
              {
                label: "CNIX",
                value: "https://raw.githubusercontent.com/Mazeorz/airports/master/Clash/SSRcloud.ini"
              },
              {
                label: "Nirvana",
                value: "https://raw.githubusercontent.com/Mazetsz/ACL4SSR/master/Clash/config/V2rayPro.ini"
              },
              {
                label: "V2Pro",
                value: "https://raw.githubusercontent.com/Mazeorz/airports/master/Clash/V2Pro.ini"
              },
              {
                label: "史迪仔-自动测速",
                value: "https://raw.githubusercontent.com/Mazeorz/airports/master/Clash/Stitch.ini"
              },
              {
                label: "史迪仔-负载均衡",
                value: "https://raw.githubusercontent.com/Mazeorz/airports/master/Clash/Stitch-Balance.ini"
              },
              {
                label: "Maying",
                value: "https://raw.githubusercontent.com/SleepyHeeead/subconverter-config/master/remote-config/customized/maying.ini"
              },
              {
                label: "Ytoo",
                value: "https://subweb.s3.fr-par.scw.cloud/RemoteConfig/customized/ytoo.ini"
              },
              {
                label: "w8ves",
                value: "https://raw.nameless13.com/api/public/dl/M-We_Fn7/w8ves.ini"
              },
              {
                label: "NyanCAT",
                value: "https://raw.githubusercontent.com/SleepyHeeead/subconverter-config/master/remote-config/customized/nyancat.ini"
              },
              {
                label: "Nexitally",
                value: "https://subweb.s3.fr-par.scw.cloud/RemoteConfig/customized/nexitally.ini"
              },
              {
                label: "SoCloud",
                value: "https://raw.githubusercontent.com/SleepyHeeead/subconverter-config/master/remote-config/customized/socloud.ini"
              },
              {
                label: "ARK",
                value: "https://raw.githubusercontent.com/SleepyHeeead/subconverter-config/master/remote-config/customized/ark.ini"
              },
              {
                label: "N3RO",
                value: "https://gist.githubusercontent.com/tindy2013/1fa08640a9088ac8652dbd40c5d2715b/raw/n3ro_optimized.ini"
              },
              {
                label: "Scholar",
                value: "https://gist.githubusercontent.com/tindy2013/1fa08640a9088ac8652dbd40c5d2715b/raw/scholar_optimized.ini"
              },
              {
                label: "Flowercloud",
                value: "https://subweb.s3.fr-par.scw.cloud/RemoteConfig/customized/flower.ini"
              }
            ]
          },
          {
            label: "特殊",
            options: [
              {
                label: "NeteaseUnblock",
                value: "https://raw.githubusercontent.com/SleepyHeeead/subconverter-config/master/remote-config/special/netease.ini"
              },
              {
                label: "Basic",
                value: "https://raw.githubusercontent.com/SleepyHeeead/subconverter-config/master/remote-config/special/basic.ini"
              }
            ]
          }
        ]
      },
      form: {
        sourceSubUrl: "",
        clientType: "",
        customBackend: this.getUrlParam() == "" ? "https://url.v1.mk" : this.getUrlParam(),
        shortType: "https://v1.mk/short",
        remoteConfig: "https://raw.githubusercontent.com/cmliu/ACL4SSR/main/Clash/config/ACL4SSR_Online.ini",
        excludeRemarks: "",
        includeRemarks: "",
        filename: "",
        rename: "",
        devid: "",
        interval: "",
        emoji: true,
        nodeList: false,
        extraset: false,
        tls13: false,
        udp: false,
        xudp: false,
        tfo: false,
        sort: false,
        expand: true,
        scv: false,
        fdn: false,
        appendType: false,
        insert: false, // 是否插入默认订阅的节点，对应配置项 insert_url
        new_name: true, // 是否使用 Clash 新字段
        tpl: {
          surge: {
            doh: false // dns 查询是否使用 DoH
          },
          clash: {
            doh: false
          },
          singbox: {
            ipv6: false
          }
        }
      },
      loading1: false,
      loading2: false,
      loading3: false,
      customSubUrl: "",
      customShortSubUrl: "",
      dialogUploadConfigVisible: false,
      loadConfig: "",
      dialogLoadConfigVisible: false,
      uploadFilter: "",
      uploadScript: "",
      uploadConfig: "",
      myBot: tgBotLink,
      filterConfig: filterConfigSample,
      scriptConfig: scriptConfigSample,
      sampleConfig: remoteConfigSample
    };
  },
  created() {
    document.title = "在线订阅转换工具";
    this.isPC = this.$getOS().isPc;
  },
  mounted() {
    //this.tanchuang();
    this.form.clientType = "clash";
    this.getBackendVersion();
    this.anhei();
    let lightMedia = window.matchMedia('(prefers-color-scheme: light)');
    let darkMedia = window.matchMedia('(prefers-color-scheme: dark)');
    let callback = (e) => {
      if (e.matches) {
        this.anhei();
      }
    };
    if (typeof darkMedia.addEventListener === 'function' || typeof lightMedia.addEventListener === 'function') {
      lightMedia.addEventListener('change', callback);
      darkMedia.addEventListener('change', callback);
    } //监听系统主题，自动切换！
  },
  methods: {
    selectChanged() {
      this.getBackendVersion();
    },
    getUrlParam() {
      let query = window.location.search.substring(1);
      let vars = query.split('&');
      for (let i = 0; i < vars.length; i++) {
        var pair = vars[i].split('=');
        if (pair[0] == "backend") {
          return decodeURIComponent(pair[1]);
        }
      }
      return "";
    },
    anhei() {
      const getLocalTheme = window.localStorage.getItem("localTheme");
      const lightMode = window.matchMedia && window.matchMedia('(prefers-color-scheme: light)');
      const darkMode = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)');
      if (getLocalTheme) {
        document.getElementsByTagName('body')[0].className = getLocalTheme;
      } //读取localstorage，优先级最高！
      else if (getLocalTheme == null || getLocalTheme == "undefined" || getLocalTheme == "") {
        if (new Date().getHours() >= 19 || new Date().getHours() < 7) {
          document.getElementsByTagName('body')[0].setAttribute('class', 'dark-mode');
        } else {
          document.getElementsByTagName('body')[0].setAttribute('class', 'light-mode');
        } //根据当前时间来判断，用来对付QQ等不支持媒体变量查询的浏览器
        if (lightMode && lightMode.matches) {
          document.getElementsByTagName('body')[0].setAttribute('class', 'light-mode');
        }
        if (darkMode && darkMode.matches) {
          document.getElementsByTagName('body')[0].setAttribute('class', 'dark-mode');
        } //根据窗口主题来判断当前主题！
      }
    },
    change() {
      var zhuti = document.getElementsByTagName('body')[0].className;
      if (zhuti === 'light-mode') {
        document.getElementsByTagName('body')[0].setAttribute('class', 'dark-mode');
        window.localStorage.setItem('localTheme', 'dark-mode');
      }
      if (zhuti === 'dark-mode') {
        document.getElementsByTagName('body')[0].setAttribute('class', 'light-mode');
        window.localStorage.setItem('localTheme', 'light-mode');
      }
    },
    tanchuang() {
      this.$alert(`<div style="text-align:center;font-size:15px"><strong><span style="font-size:20px;color:red">apiurl.v1.mk已被蔷，请更换最新的url.v1.mk</span></strong></br><strong><span style="font-size:20px">本站官方TG交流群：</span><span><a href="https://t.me/feiyangdigital" target="_blank" style="color:red;font-size:20px;text-decoration:none">点击加入</a></span></strong></br><strong><span style="font-size:20px">IEPL高端机场（<span style="color:blue">原生支持奈飞非自制剧、Disney Plus、HBO等各种流媒体，支持Chat-GPT和ISP住宅IP助力Tiktok等跨境贸易使用</span>）：</span><span><a href="https://www.mcwy.org" style="color:red;font-size:20px;text-decoration:none">点击注册</a></span></strong></br><strong><span style="font-size:20px">奈飞、ChatGPT合租（<span style="color:blue">优惠码：feiyang</span>）：</span><span><a href="https://hezu.v1.mk/" style="color:red;font-size:20px;text-decoration:none">点击上车</a></span></strong></br><strong><span style="font-size:20px">115蓝光4K原盘内部资源群：</span><span><a href="https://115.metshop.top" target="_blank" style="color:red;font-size:20px;text-decoration:none">点击查看</a></span></strong></br>本站服务器赞助机场-牧场物语，是一家拥有BGP中继+IEPL企业级内网专线的高端机场，适合各个价位要求的用户，牧场物语采用最新的奈飞非自制剧解决方案，出口随机更换IP，确保尽可能的每个用户可以用上独立IP，以此来稳定解决奈飞非自制剧的封锁，并推出7*24小时奈飞非自制剧节点自动检测系统，用户再也不用自己手动一个个的乱试节点了，目前牧场的新加坡，台湾等节区域点均可做到24H稳定非自制剧观看，支持Chat-GPT和ISP住宅IP助力Tiktok等跨境贸易使用！</br></div>`, '信息面板', {
        confirmButtonText: '确定',
        dangerouslyUseHTMLString: true,
        customClass: 'msgbox'
      });
    },
    onCopy() {
      this.$message.success("已复制");
    },
    goToProject() {
      window.open(project);
    },
    gotoTgChannel() {
      window.open(tgBotLink);
    },
    gotoBiliBili() {
      window.open(bzlink);
    },
    gotoYouTuBe() {
      window.open(yglink);
    },
    gotoBasicVideo() {
      this.$alert("别忘了关注友善的肥羊哦！", {
        type: "warning",
        confirmButtonText: '确定',
        customClass: 'msgbox',
        showClose: false,
      })
        .then(() => {
          window.open(basicVideo);
        });
    },
    gotoAdvancedVideo() {
      this.$alert("别忘了关注友善的肥羊哦！", {
        type: "warning",
        confirmButtonText: '确定',
        customClass: 'msgbox',
        showClose: false,
      })
        .then(() => {
          window.open(advancedVideo);
        });
    },
    makeUrl() {
      if (this.form.sourceSubUrl === "" || this.form.clientType === "") {
        this.$message.error("订阅链接与客户端为必填项");
        return false;
      }
      let backend =
        this.form.customBackend === ""
          ? defaultBackend
          : this.form.customBackend;
      let sourceSub = this.form.sourceSubUrl;
      sourceSub = sourceSub.replace(/(\n|\r|\n\r)/g, "|");
      this.customSubUrl =
        backend +
        "/sub?target=" +
        this.form.clientType +
        "&url=" +
        encodeURIComponent(sourceSub) +
        "&insert=" +
        this.form.insert;
      if (this.form.remoteConfig !== "") {
        this.customSubUrl +=
          "&config=" + encodeURIComponent(this.form.remoteConfig);
      }
      if (this.form.excludeRemarks !== "") {
        this.customSubUrl +=
          "&exclude=" + encodeURIComponent(this.form.excludeRemarks);
      }
      if (this.form.includeRemarks !== "") {
        this.customSubUrl +=
          "&include=" + encodeURIComponent(this.form.includeRemarks);
      }
      if (this.form.filename !== "") {
        this.customSubUrl +=
          "&filename=" + encodeURIComponent(this.form.filename);
      }
      if (this.form.rename !== "") {
        this.customSubUrl +=
          "&rename=" + encodeURIComponent(this.form.rename);
      }
      if (this.form.interval !== "") {
        this.customSubUrl +=
          "&interval=" + encodeURIComponent(this.form.interval * 86400);
      }
      if (this.form.devid !== "") {
        this.customSubUrl +=
          "&dev_id=" + encodeURIComponent(this.form.devid);
      }
      if (this.form.appendType) {
        this.customSubUrl +=
          "&append_type=" + this.form.appendType.toString();
      }
      if (this.form.tls13) {
        this.customSubUrl +=
          "&tls13=" + this.form.tls13.toString();
      }
      if (this.form.sort) {
        this.customSubUrl +=
          "&sort=" + this.form.sort.toString();
      }
      this.customSubUrl +=
        "&emoji=" +
        this.form.emoji.toString() +
        "&list=" +
        this.form.nodeList.toString() +
        "&xudp=" +
        this.form.xudp.toString() +
        "&udp=" +
        this.form.udp.toString() +
        "&tfo=" +
        this.form.tfo.toString() +
        "&expand=" +
        this.form.expand.toString() +
        "&scv=" +
        this.form.scv.toString() +
        "&fdn=" +
        this.form.fdn.toString();
      if (this.form.clientType.includes("surge")) {
        if (this.form.tpl.surge.doh === true) {
          this.customSubUrl += "&surge.doh=true";
        }
      }
      if (this.form.clientType === "clash") {
        if (this.form.tpl.clash.doh === true) {
          this.customSubUrl += "&clash.doh=true";
        }
        this.customSubUrl += "&new_name=" + this.form.new_name.toString();
      }
      if (this.form.clientType === "singbox") {
        if (this.form.tpl.singbox.ipv6 === true) {
          this.customSubUrl += "&singbox.ipv6=1";
        }
      }
      this.$copyText(this.customSubUrl);
      this.$message.success("定制订阅已复制到剪贴板");
    },
    makeShortUrl() {
      let duan =
        this.form.shortType === ""
          ? shortUrlBackend
          : this.form.shortType;
      this.loading1 = true;
      let data = new FormData();
      data.append("longUrl", btoa(this.customSubUrl));
      if (this.customShortSubUrl.trim() != "") {
        data.append("shortKey", this.customShortSubUrl.trim().indexOf("http") < 0 ? this.customShortSubUrl.trim() : "");
      }
      this.$axios
        .post(duan, data, {
          header: {
            "Content-Type": "application/form-data; charset=utf-8"
          }
        })
        .then(res => {
          if (res.data.Code === 1 && res.data.ShortUrl !== "") {
            this.customShortSubUrl = res.data.ShortUrl;
            this.$copyText(res.data.ShortUrl);
            this.$message.success("短链接已复制到剪贴板（IOS设备和Safari浏览器不支持自动复制API，需手动点击复制按钮）");
          } else {
            this.$message.error("短链接获取失败：" + res.data.Message);
          }
        })
        .catch(() => {
          this.$message.error("短链接获取失败");
        })
        .finally(() => {
          this.loading1 = false;
        });
    },
    confirmUploadConfig() {
      this.loading2 = true;
      let data = new FormData();
      data.append("config", encodeURIComponent(this.uploadConfig));
      this.$axios
        .post(configUploadBackend, data, {
          header: {
            "Content-Type": "application/form-data; charset=utf-8"
          }
        })
        .then(res => {
          if (res.data.code === 0 && res.data.data !== "") {
            this.$message.success(
              "远程配置上传成功，配置链接已复制到剪贴板"
            );
            this.form.remoteConfig = res.data.data;
            this.$copyText(this.form.remoteConfig);
            this.dialogUploadConfigVisible = false;
          } else {
            this.$message.error("远程配置上传失败: " + res.data.msg);
          }
        })
        .catch(() => {
          this.$message.error("远程配置上传失败");
        })
        .finally(() => {
          this.loading2 = false;
        });
    },
    analyzeUrl() {
      if (this.loadConfig.indexOf("target") !== -1) {
        return this.loadConfig;
      } else {
        this.loading3 = true;
        return (async () => {
          try {
            let response = await fetch(this.loadConfig, {
              method: "GET",
              redirect: "follow",
            });
            return response.url;
          } catch (e) {
            this.$message.error("解析短链接失败，请检查短链接服务端是否配置跨域：" + e)
          } finally {
            this.loading3 = false;
          }
        })();
      }
    },
    confirmLoadConfig() {
      if (this.loadConfig.trim() === "" || !this.loadConfig.trim().includes("http")) {
        this.$message.error("待解析的订阅链接不合法");
        return false;
      }
      (async () => {
        let url
        try {
          url = new URL(await this.analyzeUrl())
        } catch (error) {
          this.$message.error("请输入正确的订阅地址!");
          return;
        }
        this.form.customBackend = url.origin
        let param = new URLSearchParams(url.search);
        if (param.get("target")) {
          let target = param.get("target");
          if (target === 'surge' && param.get("ver")) {
            // 类型为surge,有ver
            this.form.clientType = target + "&ver=" + param.get("ver");
          } else if (target === 'surge') {
            //类型为surge,没有ver
            this.form.clientType = target + "&ver=4"
          } else {
            //类型为其他
            this.form.clientType = target;
          }
        }
        if (param.get("url")) {
          this.form.sourceSubUrl = param.get("url");
        }
        if (param.get("insert")) {
          this.form.insert = param.get("insert") === 'true';
        }
        if (param.get("config")) {
          this.form.remoteConfig = param.get("config");
        }
        if (param.get("exclude")) {
          this.form.excludeRemarks = param.get("exclude");
        }
        if (param.get("include")) {
          this.form.includeRemarks = param.get("include");
        }
        if (param.get("filename")) {
          this.form.filename = param.get("filename");
        }
        if (param.get("rename")) {
          this.form.rename = param.get("rename");
        }
        if (param.get("interval")) {
          this.form.interval = Math.ceil(param.get("interval") / 86400);
        }
        if (param.get("dev_id")) {
          this.form.devid = param.get("dev_id");
        }
        if (param.get("append_type")) {
          this.form.appendType = param.get("append_type") === 'true';
        }
        if (param.get("tls13")) {
          this.form.tls13 = param.get("tls13");
        }
        if (param.get("xudp")) {
          this.form.xudp = param.get("xudp") === 'true';
        }
        if (param.get("sort")) {
          this.form.sort = param.get("sort") === 'true';
        }
        if (param.get("emoji")) {
          this.form.emoji = param.get("emoji") === 'true';
        }
        if (param.get("list")) {
          this.form.nodeList = param.get("list") === 'true';
        }
        if (param.get("udp")) {
          this.form.udp = param.get("udp") === 'true';
        }
        if (param.get("tfo")) {
          this.form.tfo = param.get("tfo") === 'true';
        }
        if (param.get("expand")) {
          this.form.expand = param.get("expand") === 'true';
        }
        if (param.get("scv")) {
          this.form.scv = param.get("scv") === 'true';
        }
        if (param.get("fdn")) {
          this.form.fdn = param.get("fdn") === 'true';
        }
        if (param.get("surge.doh")) {
          this.form.tpl.surge.doh = param.get("surge.doh") === 'true';
        }
        if (param.get("clash.doh")) {
          this.form.tpl.clash.doh = param.get("clash.doh") === 'true';
        }
        if (param.get("new_name")) {
          this.form.new_name = param.get("new_name") === 'true';
        }
        if (param.get("singbox.ipv6")) {
          this.form.tpl.singbox.ipv6 = param.get("singbox.ipv6") === '1';
        }
        this.dialogLoadConfigVisible = false;
        this.$message.success("长/短链接已成功解析为订阅信息");
      })();
    },
    renderPost() {
      let data = new FormData();
      data.append("target", encodeURIComponent(this.form.clientType));
      data.append("url", encodeURIComponent(this.form.sourceSubUrl));
      data.append("config", encodeURIComponent(this.form.remoteConfig));
      data.append("exclude", encodeURIComponent(this.form.excludeRemarks));
      data.append("include", encodeURIComponent(this.form.includeRemarks));
      data.append("rename", encodeURIComponent(this.form.rename));
      data.append("tls13", encodeURIComponent(this.form.tls13.toString()));
      data.append("xudp", encodeURIComponent(this.form.xudp.toString()));
      data.append("emoji", encodeURIComponent(this.form.emoji.toString()));
      data.append("list", encodeURIComponent(this.form.nodeList.toString()));
      data.append("udp", encodeURIComponent(this.form.udp.toString()));
      data.append("tfo", encodeURIComponent(this.form.tfo.toString()));
      data.append("expand", encodeURIComponent(this.form.expand.toString()));
      data.append("scv", encodeURIComponent(this.form.scv.toString()));
      data.append("fdn", encodeURIComponent(this.form.fdn.toString()));
      data.append("sdoh", encodeURIComponent(this.form.tpl.surge.doh.toString()));
      data.append("cdoh", encodeURIComponent(this.form.tpl.clash.doh.toString()));
      data.append("newname", encodeURIComponent(this.form.new_name.toString()));
      return data;
    },
    confirmUploadScript() {
      if (this.form.sourceSubUrl.trim() === "") {
        this.$message.error("订阅链接不能为空");
        return false;
      }
      this.loading2 = true;
      let data = this.renderPost();
      data.append("sortscript", encodeURIComponent(this.uploadScript));
      data.append("filterscript", encodeURIComponent(this.uploadFilter));
      this.$axios
        .post(configScriptBackend, data, {
          header: {
            "Content-Type": "application/form-data; charset=utf-8"
          }
        })
        .then(res => {
          if (res.data.code === 0 && res.data.data !== "") {
            this.$message.success(
              "自定义JS上传成功，订阅链接已复制到剪贴板（IOS设备和Safari浏览器不支持自动复制API，需手动点击复制按钮）"
            );
            this.customSubUrl = res.data.data;
            this.$copyText(res.data.data);
            this.dialogUploadConfigVisible = false;
            this.btnBoolean = true;
          } else {
            this.$message.error("自定义JS上传失败: " + res.data.msg);
          }
        })
        .catch(() => {
          this.$message.error("自定义JS上传失败");
        })
        .finally(() => {
          this.loading2 = false;
        })
    },
    getBackendVersion() {
      this.$axios
        .get(
          this.form.customBackend + "/version"
        )
        .then(res => {
          this.backendVersion = res.data.replace(/backend\n$/gm, "");
          this.backendVersion = this.backendVersion.replace("subconverter", "SubConverter");
          let b = this.form.customBackend.indexOf("127.0.0.1") !== -1;
          b ? this.$message.success(`${this.backendVersion}` + "本地局域网自建版后端") : this.$message.success(`${this.backendVersion}`);
        })
        .catch(() => {
          this.$message.error("请求SubConverter版本号返回数据失败，该后端不可用！");
        });
    }
  }
};
</script>
<style>
.light-mode .subconverter-page {
  --page-surface: #d8e0e5;
  --page-grid: rgba(51, 65, 85, 0.05);
  --bg: rgba(241, 245, 247, 0.84);
  --panel: rgba(246, 249, 250, 0.92);
  --soft: #e5ecef;
  --text: #000;
  --muted: rgba(15, 23, 42, 0.66);
  --line: rgba(51, 65, 85, 0.12);
  --accent: #2f6f68;
  --accent-strong: #4e708b;
  --accent-fog: rgba(78, 112, 139, 0.12);
  --accent-ring: rgba(78, 112, 139, 0.16);
  --accent-outline: rgba(78, 112, 139, 0.42);
  --shadow: 0 24px 56px rgba(51, 65, 85, 0.12);
}

.dark-mode .subconverter-page {
  --page-surface: transparent;
  --page-grid: rgba(148, 163, 184, 0.05);
  --bg: rgba(7, 16, 30, 0.78);
  --panel: rgba(8, 20, 38, 0.92);
  --soft: rgba(15, 23, 42, 0.7);
  --text: #f8fbff;
  --muted: rgba(226, 232, 240, 0.7);
  --line: rgba(148, 163, 184, 0.16);
  --accent: #38bdf8;
  --accent-strong: #67e8f9;
  --accent-fog: rgba(56, 189, 248, 0.16);
  --accent-ring: rgba(56, 189, 248, 0.14);
  --accent-outline: rgba(56, 189, 248, 0.45);
  --shadow: 0 30px 80px rgba(2, 6, 23, 0.52);
}

.subconverter-page {
  position: relative;
  min-height: 100vh;
  padding: 28px 18px 104px;
  color: var(--text);
  font-family: "Noto Sans SC", sans-serif;
  overflow: hidden;
  background-color: var(--page-surface);
  background-image:
    linear-gradient(var(--page-grid) 1px, transparent 1px),
    linear-gradient(90deg, var(--page-grid) 1px, transparent 1px);
  background-size: 24px 24px;
}

.subconverter-glow {
  position: absolute;
  border-radius: 999px;
  filter: blur(18px);
  pointer-events: none;
}

.subconverter-glow--one {
  left: -120px;
  top: 20px;
  width: 320px;
  height: 320px;
  background: radial-gradient(circle, rgba(34, 211, 238, 0.24) 0, rgba(34, 211, 238, 0) 72%);
}

.subconverter-glow--two {
  right: -120px;
  bottom: 40px;
  width: 360px;
  height: 360px;
  background: radial-gradient(circle, rgba(16, 185, 129, 0.18) 0, rgba(16, 185, 129, 0) 72%);
}

.light-mode .subconverter-glow {
  display: none;
}

.subconverter-layout {
  position: relative;
  z-index: 1;
  width: 100%;
  max-width: 1032px;
  margin-left: auto !important;
  margin-right: auto !important;
  padding: 16px;
}

.subconverter-card,
.subconverter-dialog {
  border: 1px solid var(--line) !important;
  border-radius: 28px !important;
  background: var(--bg) !important;
  box-shadow: var(--shadow) !important;
  backdrop-filter: blur(18px) saturate(180%);
}

.subconverter-card .el-card__header,
.subconverter-card .el-card__body {
  background: transparent !important;
}

.subconverter-card .el-card__header {
  padding: 28px 28px 20px;
  border-bottom: 1px solid var(--line);
}

.subconverter-card .el-card__body {
  padding: 22px 28px 28px;
}

.subconverter-hero {
  display: flex;
  flex-direction: column;
  gap: 18px;
}

.subconverter-hero__eyebrow {
  display: inline-flex;
  font: 700 12px/1 "Space Grotesk", "Noto Sans SC", sans-serif;
  letter-spacing: 0.24em;
  text-transform: uppercase;
  color: var(--accent);
}

.subconverter-hero__topline {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  align-items: stretch;
  margin-top: 10px;
}

.subconverter-hero__title {
  margin: 0;
  display: flex;
  flex: 1 1 auto;
  align-items: center;
  min-height: 88px;
  font: 700 clamp(2.8rem, 6vw, 5.4rem)/0.92 "Space Grotesk", "Noto Sans SC", sans-serif;
  letter-spacing: -0.04em;
  color: var(--text) !important;
}

.subconverter-hero__desc {
  margin: 14px 0 0;
  color: var(--muted);
  line-height: 1.7;
}

.subconverter-hero__stats {
  flex: 0 0 clamp(320px, 34vw, 420px);
  width: clamp(320px, 34vw, 420px);
  min-width: clamp(320px, 34vw, 420px);
  max-width: clamp(320px, 34vw, 420px);
}

.subconverter-stat {
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  justify-content: center;
  width: 100%;
  height: 88px;
  padding: 16px 18px;
  overflow: hidden;
  border: 1px solid var(--line);
  border-radius: 20px;
  background:
    linear-gradient(135deg, var(--accent-fog), transparent 60%),
    var(--panel);
}

.subconverter-stat span {
  display: block;
  font-size: 12px;
  color: var(--muted);
}

.subconverter-stat strong {
  display: block;
  width: 100%;
  margin-top: 8px;
  font: 700 15px/1.4 "Space Grotesk", "Noto Sans SC", sans-serif;
  color: var(--text);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.subconverter-stat--backend strong {
  font-size: 18px;
  letter-spacing: 0.01em;
}

.subconverter-form .el-form-item {
  margin-bottom: 18px;
}

.subconverter-page .el-form-item__label {
  color: var(--text) !important;
  font-weight: 700;
  padding-bottom: 8px;
}

.subconverter-page .el-input__inner,
.subconverter-page .el-textarea__inner {
  border: 1px solid transparent !important;
  border-radius: 16px !important;
  background: var(--soft) !important;
  color: var(--text) !important;
  font-family: "JetBrains Mono", "Noto Sans SC", monospace;
}

.subconverter-page .el-input__inner {
  height: 46px;
}

.subconverter-page .el-textarea__inner {
  padding: 14px 16px;
}

.subconverter-page .el-input__inner:focus,
.subconverter-page .el-textarea__inner:focus,
.subconverter-page .el-select .el-input.is-focus .el-input__inner {
  border-color: var(--accent-outline) !important;
  box-shadow: 0 0 0 4px var(--accent-ring);
}

.subconverter-page .el-input__inner::-webkit-input-placeholder,
.subconverter-page .el-textarea__inner::-webkit-input-placeholder {
  color: var(--muted) !important;
}

.subconverter-main-btn {
  border-radius: 16px !important;
}

.subconverter-advanced__wrap {
  margin-top: 10px;
  padding: 14px 16px 0;
  border: 1px solid var(--line);
  border-radius: 24px;
  background: linear-gradient(180deg, var(--accent-fog), transparent 86%);
}

.subconverter-advanced,
.subconverter-page .el-collapse-item__wrap,
.subconverter-page .el-collapse-item__header {
  background: transparent !important;
  border: 0 !important;
}

.subconverter-page .el-collapse-item__arrow {
  color: var(--muted);
}

.subconverter-output {
  margin-bottom: 18px;
  padding: 16px;
  border: 1px solid var(--line);
  border-radius: 22px;
  background: var(--panel);
}

.subconverter-output .el-form-item__content {
  margin-left: 0 !important;
}

.subconverter-output .el-input-group__append,
.subconverter-output .el-input-group__prepend {
  border-color: transparent !important;
  background: transparent !important;
}

.subconverter-output .el-input-group__append {
  padding-left: 10px !important;
}

.subconverter-output .el-input-group__append .el-button {
  margin-left: 2px;
  border-radius: 12px !important;
  background: #0f172a !important;
  color: #fff !important;
}

.dark-mode .subconverter-output .el-input-group__append .el-button {
  background: #e2e8f0 !important;
  color: #020617 !important;
}

.subconverter-action-row .el-form-item__content {
  display: flex;
  justify-content: center;
  gap: 14px;
  margin-left: 0 !important;
}

.subconverter-action-row .subconverter-main-btn + .subconverter-main-btn {
  margin-left: 0;
}

.subconverter-main-btn {
  width: 160px !important;
  height: 48px;
  border: 0 !important;
  background: linear-gradient(135deg, var(--accent-strong) 0, var(--accent) 100%) !important;
}

.subconverter-main-btn--alt {
  background: linear-gradient(135deg, rgba(15, 23, 42, 0.92) 0, rgba(51, 65, 85, 0.92) 100%) !important;
}

.subconverter-main-btn--parse {
  background: linear-gradient(135deg, #0369a1 0, #0ea5e9 100%) !important;
}

.subconverter-social-dock {
  position: fixed;
  right: 20px;
  bottom: 20px;
  z-index: 8;
  display: flex;
  gap: 10px;
  padding: 9px;
  border: 1px solid var(--line);
  border-radius: 999px;
  background: var(--bg);
  box-shadow: 0 18px 42px rgba(15, 23, 42, 0.12);
  backdrop-filter: blur(18px) saturate(180%);
}

.dark-mode .subconverter-social-dock {
  background: rgba(7, 16, 30, 0.78);
}

.subconverter-social-btn {
  position: relative;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 48px;
  height: 48px;
  padding: 0;
  border: 1px solid var(--line);
  border-radius: 16px;
  background:
    linear-gradient(135deg, var(--accent-fog), transparent 65%),
    var(--panel);
  color: var(--text);
  cursor: pointer;
  transition: transform 0.18s ease, border-color 0.18s ease, box-shadow 0.18s ease;
}

.subconverter-social-btn:hover {
  transform: translateY(-2px);
  border-color: var(--accent-outline);
  box-shadow: 0 12px 28px rgba(15, 23, 42, 0.16);
}

.subconverter-social-btn__icon {
  width: 20px;
  height: 20px;
}

.subconverter-theme-toggle-icon {
  font-size: 19px;
  line-height: 1;
}

.subconverter-dialog .el-dialog__header,
.subconverter-dialog .el-dialog__body,
.subconverter-dialog .el-dialog__footer {
  background: transparent !important;
}

.subconverter-dialog .el-dialog__title {
  color: var(--text);
  font: 700 18px/1.2 "Space Grotesk", "Noto Sans SC", sans-serif;
}

.subconverter-dialog .el-tabs__item,
.subconverter-dialog .el-link,
.subconverter-dialog .el-form-item__label {
  color: var(--text) !important;
}

.subconverter-dialog .el-tabs__item.is-active {
  color: var(--accent) !important;
}

.subconverter-dialog .el-tabs--card > .el-tabs__header .el-tabs__item {
  border-color: var(--line) !important;
}

.subconverter-dialog .el-tabs--card > .el-tabs__header .el-tabs__item.is-active {
  background: var(--panel) !important;
}

.subconverter-dialog .el-dialog__headerbtn .el-dialog__close {
  color: var(--muted) !important;
}

@media (max-width: 760px) {
  .subconverter-page {
    padding: 16px 10px 92px;
  }

  .subconverter-card .el-card__header,
  .subconverter-card .el-card__body {
    padding-left: 18px;
    padding-right: 18px;
  }

  .subconverter-layout {
    padding: 0;
  }

  .subconverter-hero__topline {
    flex-direction: column;
    align-items: flex-start;
  }

  .subconverter-hero__title {
    min-height: 0;
  }

  .subconverter-hero__stats {
    flex-basis: min(100%, 420px);
    width: min(100%, 420px);
    min-width: 0;
    max-width: 100%;
  }

  .subconverter-action-row .el-form-item__content {
    flex-direction: column;
  }

  .subconverter-main-btn {
    width: 100% !important;
  }

  .subconverter-social-dock {
    right: 12px;
    bottom: 12px;
    padding: 8px;
    gap: 8px;
  }

  .subconverter-social-btn {
    width: 44px;
    height: 44px;
  }
}
</style>
