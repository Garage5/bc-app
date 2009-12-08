module AttachmentsHelper
ICONS = [
  'ai', 
  'bmp', 
  'css', 
  'doc', 
  'gif', 
  'html', 
  'jpeg', 
  'jpg', 
  'mov', 
  'mp3', 
  'pdf', 
  'php', 
  'psd', 
  'rar', 
  'wmv', 
  'xml', 
  'zip'
]

def icon_url_for_filetype(filename)
  extension = filename.split('.').last
  icon = ICONS.include?(extension.downcase) ? "#{extension.upcase}.png" : "Default.png" 
  return "/images/attach_types/#{icon}"
end

def icon_or_thumbnail(a, opts = {})
  if a.image?
    image_tag(a.attachment.url(:thumb), opts)
  else
    image_tag(icon_url_for_filetype(a.attachment_file_name), {:height => 50}.merge(opts))
  end
end

end
