class TranslateLinksOnAssessmentQuestions < ActiveRecord::Migration
  def self.up
    AssessmentQuestion.find_in_batches(:conditions => "question_data LIKE '%/files/%'") do |batch|
      AssessmentQuestion.send_later_if_production_enqueue_args(:translate_links, { :priority => Delayed::LOWER_PRIORITY, :max_attempts => 1, :strand => 'mass_translate_links_migration' }, batch.map(&:id))
    end
  end

  def self.down
  end
end
