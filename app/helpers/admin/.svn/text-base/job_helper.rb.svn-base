# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

module Admin::JobHelper
  def processor_tooltip(processor)
    if processor.sampling_rate - processor.eob_qa_checked > 0
      result = "<b>Proccessor EOB Count</b> : #{processor.completed_eob} <br/> <b>Proccessor Accuracy</b> : #{processor.accuracy} <br/> <b>Sampling Rate</b>: #{processor.sampling_rate} <br/> <b>Eobs QAd</b>: #{processor.eob_qa_checked}<br/><b>Eobs pending QA</b>: #{ processor.sampling_rate - processor.eob_qa_checked}"
    else
      result = "<b>Proccessor EOB Count</b> : #{processor.completed_eob} <br/> <b>Proccessor Accuracy</b> : #{processor.accuracy} <br/> <b>Sampling Rate</b>: #{processor.sampling_rate} <br/> <b>Eobs QAd</b>: #{processor.eob_qa_checked}<br/><b>Eobs pending QA</b>: 0"
    end
    return result
  end
end
